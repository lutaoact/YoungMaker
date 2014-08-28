###
 * Using Rails-like standard naming convention for endpoints.
 * GET     /discussions              ->  index
 * POST    /discussions              ->  create
 * GET     /discussions/:id          ->  show
 * PUT     /discussions/:id          ->  update
 * DELETE  /discussions/:id          ->  destroy
 ###

'use strict'

Discussion = _u.getModel 'discussion'
CourseUtils = _u.getUtils 'course'

exports.index = (req, res, next) ->
  user = req.user
  courseId = req.query.courseId
  from = ~~req.query.from #from参数转为整数

  CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    Discussion.find
      courseId: course._id
    .populate 'postBy', '_id name avatar'
    .sort created: -1
    .limit Const.PageSize.Discussion
    .skip from
    .execQ()
  .then (discussions) ->
    res.send discussions
  , (err) ->
    next err

exports.create = (req, res, next) ->
  user     = req.user
  courseId = req.query.courseId
  body     = req.body

  CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    #don't post voteUpUsers field, it's illegal, I will override it
    #新的discussion这个字段值应该为空，所以强制赋为空数组
    body.voteUpUsers = []
    body.postBy      = user._id
    body.courseId    = courseId

    Discussion.createQ body
  .then (discussion) ->
    discussion.postBy = user #populate postBy field
    res.send 201, discussion
  , (err) ->
    next err

# Updates an existing discussion in the DB.
exports.update = (req, res) ->
  if req.body._id
    delete req.body._id
  if req.body.responseTo
    delete req.body.responseTo
  if req.body.voteUpUsers
    delete req.body.voteUpUsers

  Discussion.findOne
    _id : req.params.id
    userId : req.user.id
  , (err, discussion) ->
    return handleError err if err
    return res.send 404 if not discussion?

    updated = _.merge discussion, req.body

    updated.save (err) ->
      return handleError(err) if err
      res.json 200, discussion


# Deletes a discussion from the DB.
exports.destroy = (req, res) ->
  Discussion.findOne
    _id : req.params.id
    userId : req.user.id
  , (err, discussion) ->
    return handleError(res, err) if err
    return res.send 404 if not discussion?
    discussion.remove (err) ->
      return handleError res, err if err
      res.send 204


# call twice can cancel out the vote
exports.vote = (req, res) ->
  courseId = req.params.courseId
  userId = req.user.id
  getAuthedCourseById userId, courseId, (err, course) ->
    return handleError res, err if err
    return res.send 403 if not course?

    Discussion.findById req.params.id, (err, disc) ->
      return handleError res, err if err
      return res.send 403 if not disc?

      if req.body.vote is '1'
        # vote
        upIdx = disc.voteUpUsers.indexOf userId
        if upIdx is -1
          disc.voteUpUsers.push userId
          downIdx = disc.voteDownUsers.indexOf userId
          if downIdx isnt -1
            disc.voteDownUsers.splice downIdx,1
            disc.markModified 'voteDownUsers'
          # undo vote
        else
          disc.voteUpUsers.splice upIdx,1
        disc.markModified 'voteUpUsers'
        disc.save()
      else if req.body.vote is '-1'
        downIdx = disc.voteDownUsers.indexOf userId
        if downIdx is -1
          disc.voteDownUsers.push userId
          upIdx = disc.voteUpUsers.indexOf userId
          if upIdx isnt -1
            disc.voteUpUsers.splice upIdx, 1
            disc.markModified 'voteUpUsers'
        else
          disc.voteDownUsers.splice downIdx,1
        disc.markModified 'voteDownUsers'
        disc.save()
      res.json 200, disc

withUserInfo = (disc, user) ->
  delete disc.userId
  disc.user =
    _id: user._id
    avatar: user.avatar
    name: user.name
  disc

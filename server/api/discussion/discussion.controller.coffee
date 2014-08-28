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
  delete body._id

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

exports.update = (req, res, next) ->
  updateBody = {}
  updateBody.content   = req.body.content   if req.body.content?
  updateBody.lectureId = req.body.lectureId if req.body.lectureId?

  Discussion.findOneQ
    _id : req.params.id
    postBy : req.user.id
  .then (discussion) ->
    updated = _.extend discussion, updateBody
    do updated.saveQ
  .then (result) ->
    newValue = result[0]
    res.send newValue
  , (err) ->
    next err

exports.destroy = (req, res, next) ->
  Discussion.removeQ
    _id: req.params.id
    postBy : req.user.id
  .then () ->
    res.send 204
  , (err) ->
    next err

# call twice can cancel out the vote
exports.vote = (req, res, next) ->
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

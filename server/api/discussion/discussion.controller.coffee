###
 * Using Rails-like standard naming convention for endpoints.
 * GET     /discussions              ->  index
 * POST    /discussions              ->  create
 * GET     /discussions/:id          ->  show
 * PUT     /discussions/:id          ->  update
 * DELETE  /discussions/:id          ->  destroy
 ###

'use strict'

<<<<<<< HEAD
Discussion = _u.getModel 'discussion'
courseUtils = require '../course/course.utils'
getAuthedCourseById = courseUtils.getAuthedCourseById

# Get list of discussions
exports.index = (req, res) ->
  getAuthedCourseById req.user.id, req.params.courseId, (err, course) ->
    if err
      return handleError(res, err)
    if not course?
      return res.send 403

    # TODO: validate on query parameters
    from = req.query.from ? 0
    if !req.query.limit or req.query.limit>128
      limit = 36
    else
      limit = req.query.limit
    Discussion
    .find 'courseId': req.params.courseId
    .lean()
    .populate 'userId', "_id name avatar"
    .sort 'created': -1
    .limit limit
    .skip from
    .exec (err, discussions) ->
      if err
        return handleError res, err
      #rename userId to user
      discussions.forEach (disc) -> withUserInfo(disc, disc.userId)
      return res.json 200, discussions
=======
#TODO check auth
Discussion = ['discussion']

# Get list of discussions
exports.index = (req, res) ->
  from = req.query.from ? 0
  if !req.query.limit or req.query.limit>128
    limit = 36
  else
    limit = req.query.limit
  Discussion
  .find 'courseId': req.params.courseId
  .lean()
  .populate 'userId', "_id name avatar"
  .sort 'created': -1
  .limit limit
  .skip from
  .exec (err, discussions) ->
    if err
      return handleError(res, err)
    #rename userId to user
    discussions.forEach (disc) -> withUserInfo(disc, disc.userId)
    return res.json(200, discussions)
>>>>>>> master


# Get a single discussion
exports.show = (req, res) ->
<<<<<<< HEAD
  getAuthedCourseById req.user.id, req.params.courseId, (err, course) ->
    if err
      return handleError res, err
    if not course?
      return res.send 403

    Discussion.findById req.params.id,  (err, discussion) ->
      return handleError res, err if err
      return res.send 404 if not discussion?
      res.json 200, discussion
=======
  Discussion.findById(req.params.id,  (err, discussion) ->
    if err
      return handleError(res, err)
    if !discussion
      return res.send(404)
    return res.json(discussion)
  )
>>>>>>> master


# Creates a new discussion in the DB.
exports.create = (req, res) ->
<<<<<<< HEAD
  getAuthedCourseById req.user.id, req.params.courseId, (err, course) ->
    return handleError res, err if err
    return res.send 403 if not course?

    #TODO: why do this?
    # has permission to add a comment
    delete req.body.voteUpUsers if req.body.voteUpUsers

    req.body.userId = req.user.id
    req.body.courseId = req.params.courseId
    Discussion.create req.body, (err, discussion) ->
      return handleError(res, err) if err
      discWithUserInfo = withUserInfo(discussion.toObject(), req.user)
      res.json 201, discWithUserInfo
=======
  delete req.body.voteUpUsers if req.body.voteUpUsers
  req.body.userId = req.user.id
  req.body.courseId = req.params.courseId
  Discussion.create req.body, (err, discussion) ->
    if err
      return handleError(res, err)
    discWithUserInfo = withUserInfo(discussion.toObject(), req.user)
    return res.json(201, discWithUserInfo)
>>>>>>> master


# Updates an existing discussion in the DB.
exports.update = (req, res) ->
  if req.body._id
    delete req.body._id
  if req.body.responseTo
    delete req.body.responseTo
  if req.body.voteUpUsers
    delete req.body.voteUpUsers

<<<<<<< HEAD
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
=======
  Discussion.findOne({'_id': req.params.id, 'userId': req.user.id},  (err, discussion) ->
    if err
      return handleError(err)
    if !discussion
      return res.send(404)
    updated = _.merge(discussion, req.body)
    updated.save( (err) ->
      if err
        return handleError(err)
      return res.json(200, discussion)
    )
  )
>>>>>>> master


# Deletes a discussion from the DB.
exports.destroy = (req, res) ->
<<<<<<< HEAD
  Discussion.findOne
    _id : req.params.id
    userId : req.user.id
  , (err, discussion) ->
    return handleError(res, err) if err
    return res.send 404 if not discussion?
    discussion.remove (err) ->
      return handleError res, err if err
      res.send 204
=======
  Discussion.findOne({'_id': req.params.id, 'userId': req.user.id},  (err, discussion) ->
    if err
      return handleError(res, err)
    if !discussion
      return res.send(404)
    discussion.remove((err) ->
      if err
        return handleError(res, err)
      return res.send(204)
    )
  )
>>>>>>> master


# call twice can cancel out the vote
exports.vote = (req, res) ->
<<<<<<< HEAD
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
=======
  userId = req.user.id
  Discussion.findById req.params.id, (err, disc) ->
    if err
      return handleError(res, err)
    if !disc
      return res.send(403)
    if req.body.vote == '1'
      # vote
      upIdx = disc.voteUpUsers.indexOf(userId)
      if upIdx == -1
        disc.voteUpUsers.push userId
        downIdx = disc.voteDownUsers.indexOf(userId)
        if downIdx != -1
          disc.voteDownUsers.splice downIdx,1
          disc.markModified 'voteDownUsers'
      # undo vote
      else
        disc.voteUpUsers.splice upIdx,1
      disc.markModified 'voteUpUsers'
      disc.save()
    else if req.body.vote == '-1'
      downIdx = disc.voteDownUsers.indexOf(userId)
      if downIdx == -1
        disc.voteDownUsers.push userId
        upIdx = disc.voteUpUsers.indexOf(userId)
        if upIdx != -1
          disc.voteUpUsers.splice upIdx,1
          disc.markModified 'voteUpUsers'
      else
        disc.voteDownUsers.splice downIdx,1
      disc.markModified 'voteDownUsers'
      disc.save()
    return res.json(200, disc)
>>>>>>> master

withUserInfo = (disc, user) ->
  delete disc.userId
  disc.user =
    _id: user._id
    avatar: user.avatar
    name: user.name
  disc

handleError = (res, err) ->
<<<<<<< HEAD
  return res.send 500, err
=======
  return res.send(500, err)
>>>>>>> master

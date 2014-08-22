###
 * Using Rails-like standard naming convention for endpoints.
 * GET     /discussions              ->  index
 * POST    /discussions              ->  create
 * GET     /discussions/:id          ->  show
 * PUT     /discussions/:id          ->  update
 * DELETE  /discussions/:id          ->  destroy
 ###

'use strict'

Discussion = modelMap['discussion']
lectureUtils = require('../lecture/lecture.utils')
getAuthedLectureById = lectureUtils.getAuthedLectureById

# Get list of discussions
exports.index = (req, res) ->
  getAuthedLectureById req.user.id, req.params.lectureId, (err, lecture) ->
    if err
      return handleError(res, err)
    if !lecture
      return res.send(403)
    # TODO: validate on query parameters
    from = req.query.from ? 0
    if !req.query.limit or req.query.limit>128
      limit = 36
    else
      limit = req.query.limit
    Discussion
    .find 'lectureId': req.params.lectureId
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


# Get a single discussion
exports.show = (req, res) ->
  getAuthedLectureById req.user.id, req.params.lectureId, (err, lecture) ->
    if err
      return handleError(res, err)
    if !lecture
      return res.send(403)
    Discussion.findById(req.params.id,  (err, discussion) ->
      if err
        return handleError(res, err)
      if !discussion
        return res.send(404)
      return res.json(discussion)
    )


# Creates a new discussion in the DB.
exports.create = (req, res) ->
  getAuthedLectureById req.user.id, req.params.lectureId, (err, lecture) ->
    if err
      return handleError(res, err)
    if !lecture
      return res.send(403)
    # has permission to add a comment
    delete req.body.voteUpUsers if req.body.voteUpUsers
    req.body.userId = req.user.id
    req.body.lectureId = req.params.lectureId
    Discussion.create req.body, (err, discussion) ->
      if err
        return handleError(res, err)
      discWithUserInfo = withUserInfo(discussion.toObject(), req.user)
      return res.json(201, discWithUserInfo)


# Updates an existing discussion in the DB.
exports.update = (req, res) ->
  if req.body._id
    delete req.body._id
  if req.body.responseTo
    delete req.body.responseTo
  if req.body.voteUpUsers
    delete req.body.voteUpUsers

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


# Deletes a discussion from the DB.
exports.destroy = (req, res) ->
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


# call twice can cancel out the vote
exports.vote = (req, res) ->
  lectureId = req.params.lectureId
  userId = req.user.id
  getAuthedLectureById userId, lectureId, (err, lecture) ->
    if err
      return handleError(res, err)
    if !lecture
      return res.send(403)

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

withUserInfo = (disc, user) ->
  delete disc.userId
  disc.user =
    _id: user._id
    avatar: user.avatar
    name: user.name
  disc

handleError = (res, err) ->
  return res.send(500, err)


#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /key_points              ->  index
# * GET     /key_points/:id          ->  show
# * POST    /key_points              ->  create
# * DELETE  /key_points/:id          ->  destroy
#

"use strict"

KeyPoint = _u.getModel "key_point"
Lecture = _u.getModel "lecture"

exports.index = (req, res, next) ->
  conditions = {}
  conditions.categoryId = req.query.categoryId if req.query.categoryId

  KeyPoint.findQ conditions
  .then (keyPoints) ->
    res.send keyPoints
  , (err) ->
    next err

exports.show = (req, res, next) ->
  KeyPoint.findByIdQ req.params.id
  .then (keyPoint) ->
    res.send keyPoint
  , (err) ->
    next err

exports.create = (req, res, next) ->
  KeyPoint.createQ req.body
  .then (keyPoint) ->
    res.send 201, keyPoint
  , (err) ->
    next err

exports.searchByKeyword = (req, res, next) ->
  name = req.params.name
  escape = name.replace /[{}()^$|.\[\]*?+]/g, '\\$&'
  regex = new RegExp(escape)
  logger.info regex

  KeyPoint.findQ
    name: regex
  .then (keyPoints) ->
    res.send keyPoints
  , (err) ->
    next err

#TODO: will support destroy later
#exports.destroy = (req, res) ->
#  Lecture.find
#    keyPoints: req.params.id
#  , (err, lectures) ->
#    return handleError(res, err)  if err
#    # forbid deleting if it is referenced by Lecture
#    unless lectures.length is 0
#      res.send 400
#    else
#      KeyPoint.findById req.params.id, (err, keyPoint) ->
#        return handleError(res, err)  if err
#        return res.send(404)  unless keyPoint
#        keyPoint.remove (err) ->
#          return handleError(res, err)  if err
#          res.send 204
#
### copied from course controller, need to implement these logic in above methods

  # insert keyPoint id to this Lecture; create a keyPoint when _id is not provided
exports.createKeyPoint = (req, res) ->
  updateLectureKeyPoints = (keyPoint) ->
    Lecture.findByIdAndUpdate req.params.lectureId,
      $push:
        keyPoints: keyPoint._id
    , (err, lecture) ->
      return handleError(res, err)  if err
      res.send keyPoint

  Course.findOne(
    _id: req.params.id
    owners:
      $in: [req.user.id]
  ).exec (err, course) ->
    return handleError(res, err)  if err
    return res.send(404)  unless course
    if req.body._id # TODO: validate this _id!
      updateLectureKeyPoints req.body
    else
      KeyPoint.create req.body, (err, keyPoint) ->
        return handleError(err)  if err
        updateLectureKeyPoints keyPoint


exports.showKeyPoints = (req, res) ->
  Lecture.findById(req.params.lectureId).populate("keyPoints").exec (err, lecture) ->
    return handleError(res, err)  if err
    return res.send(404)  unless lecture
    res.json lecture.keyPoints

###

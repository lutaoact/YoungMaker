
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /key_points              ->  index
# * POST    /key_points              ->  create
# * GET     /key_points/:id          ->  show
# * PUT     /key_points/:id          ->  update
# * DELETE  /key_points/:id          ->  destroy
#

"use strict"

_ = require("lodash")
KeyPoint = _u.getModel "key_point"
Lecture = _u.getModel "lecture"


exports.index = (req, res) ->
  conditions = {}
  conditions = categoryId: req.query.categoryId  if req.query.categoryId
  KeyPoint.find conditions, (err, categories) ->
    return handleError(res, err)  if err
    res.json 200, categories


exports.show = (req, res) ->
  KeyPoint.findById req.params.id, (err, keyPoint) ->
    return handleError(res, err)  if err
    return res.send(404)  unless keyPoint
    res.json keyPoint


exports.create = (req, res) ->
  KeyPoint.create req.body, (err, keyPoint) ->
    return handleError(res, err)  if err
    res.json 201, keyPoint


exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  KeyPoint.findById req.params.id, (err, keyPoint) ->
    return handleError(err)  if err
    return res.send(404)  unless keyPoint
    updated = _.extend(keyPoint, req.body)
    updated.save (err) ->
      return handleError(err)  if err
      res.json 200, keyPoint


exports.destroy = (req, res) ->
  Lecture.find
    keyPoints: req.params.id
  , (err, lectures) ->
    return handleError(res, err)  if err
    # forbid deleting if it is referenced by Lecture
    unless lectures.length is 0
      res.send 400
    else
      KeyPoint.findById req.params.id, (err, keyPoint) ->
        return handleError(res, err)  if err
        return res.send(404)  unless keyPoint
        keyPoint.remove (err) ->
          return handleError(res, err)  if err
          res.send 204

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
handleError = (res, err) ->
  res.send 500, err

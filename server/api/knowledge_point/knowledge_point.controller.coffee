
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /knowledge_points              ->  index
# * POST    /knowledge_points              ->  create
# * GET     /knowledge_points/:id          ->  show
# * PUT     /knowledge_points/:id          ->  update
# * DELETE  /knowledge_points/:id          ->  destroy
#

"use strict"

_ = require("lodash")
KnowledgePoint = _u.getModel "knowledge_point"
Lecture = _u.getModel "lecture"


exports.index = (req, res) ->
  conditions = {}
  conditions = categoryId: req.query.categoryId  if req.query.categoryId
  KnowledgePoint.find conditions, (err, categories) ->
    return handleError(res, err)  if err
    res.json 200, categories


exports.show = (req, res) ->
  KnowledgePoint.findById req.params.id, (err, knowledgePoint) ->
    return handleError(res, err)  if err
    return res.send(404)  unless knowledgePoint
    res.json knowledgePoint


exports.create = (req, res) ->
  KnowledgePoint.create req.body, (err, knowledgePoint) ->
    return handleError(res, err)  if err
    res.json 201, knowledgePoint


exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  KnowledgePoint.findById req.params.id, (err, knowledgePoint) ->
    return handleError(err)  if err
    return res.send(404)  unless knowledgePoint
    updated = _.extend(knowledgePoint, req.body)
    updated.save (err) ->
      return handleError(err)  if err
      res.json 200, knowledgePoint


exports.destroy = (req, res) ->
  Lecture.find
    knowledgePoints: req.params.id
  , (err, lectures) ->
    return handleError(res, err)  if err
    # forbid deleting if it is referenced by Lecture
    unless lectures.length is 0
      res.send 400
    else
      KnowledgePoint.findById req.params.id, (err, knowledgePoint) ->
        return handleError(res, err)  if err
        return res.send(404)  unless knowledgePoint
        knowledgePoint.remove (err) ->
          return handleError(res, err)  if err
          res.send 204

### copied from course controller, need to implement these logic in above methods

  # insert knowledgePoint id to this Lecture; create a knowledgePoint when _id is not provided
exports.createKnowledgePoint = (req, res) ->
  updateLectureKnowledgePoints = (knowledgePoint) ->
    Lecture.findByIdAndUpdate req.params.lectureId,
      $push:
        knowledgePoints: knowledgePoint._id
    , (err, lecture) ->
      return handleError(res, err)  if err
      res.send knowledgePoint

  Course.findOne(
    _id: req.params.id
    owners:
      $in: [req.user.id]
  ).exec (err, course) ->
    return handleError(res, err)  if err
    return res.send(404)  unless course
    if req.body._id # TODO: validate this _id!
      updateLectureKnowledgePoints req.body
    else
      KnowledgePoint.create req.body, (err, knowledgePoint) ->
        return handleError(err)  if err
        updateLectureKnowledgePoints knowledgePoint


exports.showKnowledgePoints = (req, res) ->
  Lecture.findById(req.params.lectureId).populate("knowledgePoints").exec (err, lecture) ->
    return handleError(res, err)  if err
    return res.send(404)  unless lecture
    res.json lecture.knowledgePoints

###
handleError = (res, err) ->
  res.send 500, err

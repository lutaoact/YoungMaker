
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
KnowledgePoint = require("./knowledge_point.model")
Lecture = require("../lecture/lecture.model")


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


handleError = (res, err) ->
  res.send 500, err

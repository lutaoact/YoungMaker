
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /key_points              ->  index
# * GET     /key_points/:id          ->  show
# * POST    /key_points              ->  create
# * DELETE  /key_points/:id          ->  destroy
#

"use strict"

KeyPoint = _u.getModel "key_point"
Category = _u.getModel 'category'
Lecture = _u.getModel "lecture"

exports.index = (req, res, next) ->
  conditions = orgId: req.user.orgId
  conditions._id = req.query.categoryId if req.query.categoryId

  Category.findQ conditions
  .then (categories) ->
    categoryIds = _.pluck categories, '_id'
    KeyPoint.findQ categoryId: $in: categoryIds
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
  delete req.body._id
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


#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /categories              ->  index
# * POST    /categories              ->  create
# * GET     /categories/:id          ->  show
# * PUT     /categories/:id          ->  update
# * DELETE  /categories/:id          ->  destroy
#
"use strict"

Category = _u.getModel "category"
Course = _u.getModel 'course'

exports.index = (req, res, next) ->
  Category.findQ orgId: req.user.orgId, deleteFlag: $ne: true
  .then (categories) ->
    res.send categories
  , next

exports.create = (req, res, next) ->
  body = req.body
  delete body._id

  body.orgId = req.user.orgId
  Category.createQ body
  .then (category) ->
    res.json 201, category
  , next


exports.courses = (req, res, next) ->
  Course.find categoryId: req.params.id
  .populate 'owners', "name"
  .execQ()
  .then (courses) ->
    res.send courses
  , next

exports.update = (req, res, next) ->
  Category.findByIdQ req.params.id
  .then (category) ->
    category.name = req.body.name
    do category.saveQ
  .then (result) ->
    newValue = result[0]
    res.send newValue
  , next

exports.destroy = (req, res, next) ->
  Category.removeQ
    _id: req.params.id
  .then () ->
    res.send 204
  , next

exports.multiDelete = (req, res, next) ->
  ids = req.body.ids
  Category.updateQ
    orgId: req.user.orgId
    _id: $in: ids
  ,
    deleteFlag: true
  ,
    multi: true
  .then () ->
    res.send 204
  , next

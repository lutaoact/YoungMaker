
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
WrapRequest = new (require '../../utils/WrapRequest')(Category)

exports.index = (req, res, next) ->
  conditions = orgId : req.org?._id
  WrapRequest.wrapIndex req, res, next, conditions

exports.create = (req, res, next) ->
  data = req.body
  delete data._id
  data.orgId   = req.user.orgId
  WrapRequest.wrapCreate req, res, next, data

exports.courses = (req, res, next) ->
  Course.find categoryId: req.params.id
  .populate 'owners', "name"
  .execQ()
  .then (courses) ->
    res.send courses
  , next

pickedUpdatedKeys = omit: ['_id', 'orgId', 'deleteFlag']
exports.update = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys

exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapDestroy req, res, next, conditions

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

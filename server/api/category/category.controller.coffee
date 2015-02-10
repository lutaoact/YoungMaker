
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
  conditions = {}
  WrapRequest.wrapIndex req, res, next, conditions

pickedKeys = ['name', 'logo']
exports.create = (req, res, next) ->
  data = _.pick req.body, pickedKeys
  WrapRequest.wrapCreate req, res, next, data

exports.courses = (req, res, next) ->
  Course.find categoryId: req.params.id
  .populate 'owners', "name"
  .execQ()
  .then (courses) ->
    res.send courses
  , next

pickedUpdatedKeys = ['name', 'logo']
exports.update = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys


exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapDestroy req, res, next, conditions

exports.multiDelete = (req, res, next) ->
  ids = req.body.ids
  conditions = {_id: $in: ids}
  WrapRequest.wrapDestroy req, res, next, conditions

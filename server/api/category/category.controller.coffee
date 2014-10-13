
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

exports.index = (req, res, next) ->
  Category.findQ orgId: req.user.orgId
  .then (categories) ->
    res.send categories
  , (err) ->
    next err

exports.create = (req, res, next) ->
  body = req.body
  delete body._id

  body.orgId = req.user.orgId
  Category.createQ body
  .then (category) ->
    res.json 201, category
  , (err) ->
    next err

exports.destroy = (req, res, next) ->
  Category.removeQ
    _id: req.params.id
  .then () ->
    res.send 204
  , (err) ->
    next err

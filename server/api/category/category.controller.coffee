
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /categories              ->  index
# * POST    /categories              ->  create
# * GET     /categories/:id          ->  show
# * PUT     /categories/:id          ->  update
# * DELETE  /categories/:id          ->  destroy
#
"use strict"
_ = require("lodash")
Category = _u.getModel "category"

exports.index = (req, res) ->
  Category.find (err, categories) ->
    return handleError(res, err)  if err
    res.json 200, categories


exports.show = (req, res) ->
  Category.findById req.params.id, (err, category) ->
    return handleError(res, err)  if err
    return res.send(404)  unless category
    res.json category


exports.create = (req, res) ->
  Category.create req.body, (err, category) ->
    return handleError(res, err)  if err
    res.json 201, category


exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Category.findById req.params.id, (err, category) ->
    return handleError(err)  if err
    return res.send(404)  unless category
    updated = _.extend(category, req.body)
    updated.save (err) ->
      return handleError(err)  if err
      res.json 200, category


exports.destroy = (req, res) ->
  Category.findById req.params.id, (err, category) ->
    return handleError(res, err)  if err
    return res.send(404)  unless category
    category.remove (err) ->
      return handleError(res, err)  if err
      res.send 204


handleError = (res, err) ->
  res.send 500, err


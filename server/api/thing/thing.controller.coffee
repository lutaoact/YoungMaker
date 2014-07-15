###
 * Using Rails-like standard naming convention for endpoints.
 * GET     /things              ->  index
 * POST    /things              ->  create
 * GET     /things/:id          ->  show
 * PUT     /things/:id          ->  update
 * DELETE  /things/:id          ->  destroy
 ###

'use strict'

_ = require('lodash')
Thing = require('./thing.model')

# Get list of things
exports.index = (req, res) ->
  Thing.find( (err, things) ->
    if err
      return handleError(res, err)
    return res.json(200, things)
  )


# Get a single thing
exports.show = (req, res) ->
  Thing.findById(req.params.id,  (err, thing) ->
    if err
      return handleError(res, err)
    if !thing
      return res.send(404)
    return res.json(thing)
  )


# Creates a new thing in the DB.
exports.create = (req, res) ->
  Thing.create(req.body, (err, thing) ->
    if err
      return handleError(res, err)
    return res.json(201, thing)
  )


# Updates an existing thing in the DB.
exports.update = (req, res) ->
  if req.body._id
    delete req.body._id
  Thing.findById(req.params.id,  (err, thing) ->
    if err
      return handleError(err)
    if !thing
      return res.send(404)
    updated = _.merge(thing, req.body)
    updated.save( (err) ->
      if err
        return handleError(err)
      return res.json(200, thing)
    )
  )


# Deletes a thing from the DB.
exports.destroy = (req, res) ->
  Thing.findById(req.params.id,  (err, thing) ->
    if err
      return handleError(res, err)
    if !thing
      return res.send(404)
    thing.remove((err) ->
      if err
        return handleError(res, err)
      return res.send(204)
    )
  )


handleError = (res, err) ->
  return res.send(500, err)

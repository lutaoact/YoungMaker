"use strict"
Tag = _u.getModel 'tag'

WrapRequest = new (require '../../utils/WrapRequest')(Tag)

exports.index = (req, res, next) ->
  conditions = {}
  conditions = belongTo: req.query.belongTo
  if req.query.keyword
    regex = new RegExp(_u.escapeRegex(req.query.keyword), 'i')
    conditions.text = regex
  WrapRequest.wrapIndex req, res, next, conditions

exports.show = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapIndex req, res, next, conditions

pickedKeys = ["text", "belongTo"]
exports.create = (req, res, next) ->
  data = _.pick req.body, pickedKeys
  WrapRequest.wrapCreate req, res, next, data

pickedUpdatedKeys = ["text", "belongTo"]
exports.update = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys

exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapDestroy req, res, next, conditions

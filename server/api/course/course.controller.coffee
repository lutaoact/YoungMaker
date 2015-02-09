'use strict'

Course = _u.getModel 'course'
WrapRequest = new (require '../../utils/WrapRequest')(Course)

exports.index = (req, res, next) ->
  conditions = {}
  conditions.author   = req.query.author if req.query.author
  WrapRequest.wrapPageIndex req, res, next, conditions

exports.show = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapShow req, res, next, conditions

pickedKeys = ['title', 'cover', 'image', 'videos', 'content', 'tags', 'steps']
exports.create = (req, res, next) ->
  data = _.pick req.body, pickedKeys
  data.author = req.user._id
  WrapRequest.wrapCreate req, res, next, data

pickedUpdatedKeys = ['title', 'cover', 'image', 'videos', 'content', 'tags', 'steps']
exports.update = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys

exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapDestroy req, res, next, conditions

exports.like = WrapRequest.wrapLike.bind WrapRequest

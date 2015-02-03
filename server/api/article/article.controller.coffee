'use strict'

Article = _u.getModel 'article'
AdapterUtils = _u.getUtils 'adapter'
WrapRequest = new (require '../../utils/WrapRequest')(Article)

indexConditionKeys = ['author', 'group']
exports.index = (req, res, next) ->
  conditions = _.pick req.query, indexConditionKeys
  WrapRequest.wrapIndex req, res, next, conditions

exports.show = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapShow req, res, next, conditions

pickedKeys = ['title', 'image', 'content', 'tags', 'group']
exports.create = (req, res, next) ->
  data = _.pick req.body, pickedKeys
  data.author = req.user._id
  WrapRequest.wrapCreate req, res, next, data


pickedUpdatedKeys = ['title', 'image', 'content', 'tags', 'isPublished']
exports.update = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys


exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapDestroy req, res, next, conditions

exports.like = WrapRequest.wrapLike

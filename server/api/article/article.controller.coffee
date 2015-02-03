'use strict'

Article = _u.getModel 'article'
AdapterUtils = _u.getUtils 'adapter'
Group = _u.getModel 'group'
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
  #TODO: check if user is group number
  data = _.pick req.body, pickedKeys
  data.author = req.user._id

  updateConds = {_id: data.group}
  update = {$inc: {postsCount: 1}}

  WrapRequest.wrapCreateAndUpdate req, res, next, data, Group, updateConds, update

pickedUpdatedKeys = ['title', 'image', 'content', 'tags', 'isPublished']
exports.update = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys


exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapDestroy req, res, next, conditions

exports.like = WrapRequest.wrapLike

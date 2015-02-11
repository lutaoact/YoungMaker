'use strict'

Article = _u.getModel 'article'
AdapterUtils = _u.getUtils 'adapter'
Group = _u.getModel 'group'
WrapRequest = new (require '../../utils/WrapRequest')(Article)

exports.index = (req, res, next) ->
  conditions = {}
  conditions.author = req.query.author if req.query.author
  conditions.author = req.query.group if req.query.group
  # filter by keyword
  if req.query.keyword
    regex = new RegExp(_u.escapeRegex(req.query.keyword), 'i')
    conditions.$or = [
      'title': regex
    ,
      'content': regex
    ]
  WrapRequest.wrapPageIndex req, res, next, conditions

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

exports.like = WrapRequest.wrapLike.bind WrapRequest


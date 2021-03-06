'use strict'

Course = _u.getModel 'course'
WrapRequest = new (require '../../utils/WrapRequest')(Course)
testFilter = require '../../common/contentFilter'


exports.index = (req, res, next) ->
  conditions = {}
  conditions.author = req.query.author if req.query.author
  conditions.categoryId = req.query.category if req.query.category

  # filter by tags
  queryTags = null
  try
    queryTags = JSON.parse(req.query.tags) if req.query.tags
  catch e
    queryTags = null

  if queryTags?.length
    conditions.tags = $in: queryTags

  conditions.featured = {'$ne':null} if req.query.featured

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
  update = $inc: {viewersNum: 1} if req.query.viewer?
  WrapRequest.wrapShow req, res, next, conditions, update

exports.create = (req, res, next) ->
  pickedKeys = ['title', 'cover', 'info', 'categoryId', 'image', 'videos', 'content', 'tags', 'steps']
  if req.user.role is 'admin'
    pickedKeys.push 'featured'
  data = _.pick req.body, pickedKeys
  testFilter(JSON.stringify data)

  data.author = req.user._id
  WrapRequest.wrapCreate req, res, next, data

exports.update = (req, res, next) ->
  pickedUpdatedKeys = ['title', 'cover', 'info', 'categoryId', 'image', 'videos', 'content', 'tags', 'steps']
  if req.user.role is 'admin'
    pickedUpdatedKeys.push 'featured'

  data = _.pick req.body, pickedUpdatedKeys
  testFilter(JSON.stringify data)

  conditions = {_id: req.params.id}
  conditions.author = req.user._id if req.user.role isnt 'admin'
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys

exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  conditions.author = req.user._id if req.user.role isnt 'admin'
  WrapRequest.wrapDestroy req, res, next, conditions

exports.like = WrapRequest.wrapLike.bind WrapRequest

'use strict'

Article = _u.getModel 'article'
AdapterUtils = _u.getUtils 'adapter'
Group = _u.getModel 'group'
WrapRequest = new (require '../../utils/WrapRequest')(Article)

exports.index = (req, res, next) ->
  conditions = {}
  conditions.author = req.query.author if req.query.author
  conditions.group = req.query.group if req.query.group
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
  WrapRequest.wrapShow req, res, next, conditions

exports.create = (req, res, next) ->
  pickedKeys = ['title', 'image', 'content', 'tags', 'group']
  if req.user.role is 'admin'
    pickedKeys.push 'featured'
  #TODO: check if user is group number
  data = _.pick req.body, pickedKeys
  data.author = req.user._id

  updateConds = {_id: data.group}
  update = {$inc: {postsCount: 1}}

  WrapRequest.wrapCreateAndUpdate req, res, next, data, Group, updateConds, update

exports.update = (req, res, next) ->
  pickedUpdatedKeys = ['title', 'image', 'content', 'tags', 'isPublished']
  if req.user.role is 'admin'
    pickedUpdatedKeys.push 'featured'
  conditions = {_id: req.params.id}
  conditions.author = req.user._id if req.user.role isnt 'admin'
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys


exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  conditions.author = req.user._id if req.user.role isnt 'admin'
  Article.findOneQ conditions
  .then (doc) ->
    if doc
      CommentUtils = _u.getUtils 'comment'
      Q.all [
        doc.updateQ {deleteFlag: true}
        CommentUtils.removeCommentsAndNotices(req.params.id)
      ]
  .then () ->
    res.send 204
  .catch next
  .done()


exports.like = WrapRequest.wrapLike.bind WrapRequest

'use strict'

Comment = _u.getModel 'comment'
AdapterUtils = _u.getUtils 'adapter'
CommentUtils = _u.getUtils 'comment'

exports.index = (req, res, next) ->
  type = req.query.type
  belongTo = req.query.belongTo

  Comment.getByTypeAndBelongTo type, belongTo
  .then (comments) ->
    res.send comments
  .catch next
  .done()

exports.create = (req, res, next) ->
  user = req.user
  body = req.body
  data =
    content : body.content
    author  : user._id
    type    : body.type
    belongTo: body.belongTo
    tags    : body.tags

  Model = CommentUtils.getCommentRefByType body.type
  Q.all [
    Comment.createQ data
    Model.updateQ {_id: belongTo}, {$inc: {viewersNum: 1}}
  ]
  .then (result) ->
    comment = result[0]
    res.send comment
  .catch next
  .done()

exports.update = (req, res, next) ->
  commentId = req.params.id
  user = req.user
  body = req.body
  #以下字段不允许外部更新，会有相应的内部处理逻辑
  body = _.omit body, ['_id', 'author', 'type', 'belongTo', 'likeUsers', 'deleteFlag']

  Comment.getByIdAndUser commentId, user._id
  .then (comment) ->
    updated = _.extend comment, body
    do updated.saveQ
  .then (result) ->
    res.send result[0]
  .catch next
  .done()

exports.destroy = (req, res, next) ->
  commentId = req.params.id
  Comment.updateQ {_id: commentId}, {deleteFlag: true}
  .then () ->
    res.send 204
  .catch next
  .done()

exports.like = (req, res, next) ->
  commentId = req.params.id
  user = req.user
  AdapterUtils.like Comment, commentId, user._id
  .then (comment) ->
    res.send comment
  .catch next
  .done()

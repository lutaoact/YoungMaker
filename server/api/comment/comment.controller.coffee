'use strict'

Comment = _u.getModel 'comment'
AdapterUtils = _u.getUtils 'adapter'
CommentUtils = _u.getUtils 'comment'
WrapRequest = new (require '../../utils/WrapRequest')(Comment)

exports.index = WrapRequest.wrapIndex()

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
    Model.updateQ {_id: data.belongTo}, {$inc: {viewersNum: 1}}
  ]
  .then (result) ->
    comment = result[0]
    res.send comment
  .catch next
  .done()

pickedUpdatedKeys = ['content', 'tags']
exports.update = WrapRequest.wrapUpdate pickedUpdatedKeys

exports.destroy = WrapRequest.wrapDestroy()

exports.like = WrapRequest.wrapLike()

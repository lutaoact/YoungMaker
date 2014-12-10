'use strict'

Article = _u.getModel 'article'
LikeUtils = _u.getUtils 'like'
WrapRequest = new (require '../../utils/WrapRequest')(Article)

exports.index = WrapRequest.wrapIndex()

exports.show = WrapRequest.wrapShow()

exports.create = (req, res, next) ->
  propertiesToSave = ['title', 'content', 'tags']
  newArticle = _.pick(req.body, propertiesToSave) # tidy new article from client side
  newArticle.author = req.user._id

  Article.createQ newArticle
  .then (dbArticle) ->
    res.send dbArticle
  .catch next
  .done()

exports.update = (req, res, next) ->
  articleId = req.params.id
  user = req.user
  body = req.body
  #以下字段不允许外部更新，会有相应的内部处理逻辑
  body = _.omit body, ['_id', 'author', 'commentsNum', 'viewersNum', 'likeUsers', 'deleteFlag']

  Article.getByIdAndAuthor articleId, user._id
  .then (article) ->
    updated = _.extend article, body
    do updated.saveQ
  .then (result) ->
    res.send result[0]
  .catch next
  .done()

exports.destroy = (req, res, next) ->
  articleId = req.params.id
  Article.updateQ {_id: articleId}, {deleteFlag: true}
  .then () ->
    res.send 204
  .catch next
  .done()

exports.like = (req, res, next) ->
  articleId = req.params.id
  user = req.user
  LikeUtils.like Article, articleId, user._id
  .then (article) ->
    res.send article
  .catch next
  .done()

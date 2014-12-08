'use strict'

Article = _u.getModel 'article'

exports.index = (req, res, next) ->
  Article.getAll()
  .then (articles) ->
    res.send articles
  .catch next
  .done()

exports.show = (req, res, next) ->
  articleId = req.params.id

  Article.findByIdQ articleId
  .then (article) ->
    article.viewersNum += 1 #每次调用API，相当于查看一次
    do article.saveQ
  .then (result) ->
    res.send result[0]
  .catch next
  .done()

exports.create = (req, res, next) ->
  user = req.user
  body = req.body
  data =
    title:  data.title
    content:data.content
    author: user._id
    tags:   data.tags

  Article.createQ data
  .then (article) ->
    res.send article
  .catch next
  .done()

exports.update = (req, res, next) ->
  articleId = req.params.id
  user = req.user
  body = req.body
  #以下字段不允许外部更新，会有相应的内部处理逻辑
  delete body._id
  delete body.author
  delete body.commentsNum
  delete body.viewersNum
  delete body.likeUsers
  delete body.deleteFlag

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

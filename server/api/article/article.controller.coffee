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

exports.destroy = (req, res, next) ->

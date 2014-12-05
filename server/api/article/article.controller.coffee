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
    res.send article
  .catch next
  .done()

exports.create = (req, res, next) ->

exports.update = (req, res, next) ->

exports.destroy = (req, res, next) ->

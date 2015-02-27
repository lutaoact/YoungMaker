# Main application routes

'use strict'

errors = require './components/errors'
jwt = require 'jsonwebtoken'
config = require './config/environment'
ejs = require 'ejs'

errorHandler = (err, req, res, next) ->
  logger.error err
  result =
    name: err?.name
    message: err?.message
    errors: err?.errors
  res.json err.status || 500, result

module.exports = (app) ->

  # Insert routes below
  app.use '/api/users', require './api/user'
  app.use '/api/articles', require './api/article'
  app.use '/api/comments', require './api/comment'
  app.use '/api/courses', require './api/course'
  app.use '/api/groups', require './api/group'
  app.use '/api/categories', require './api/category'
  app.use '/api/favorites', require './api/favorite'
  app.use '/api/assets', require './api/asset'
  app.use '/api/follows', require './api/follow'
  app.use '/api/notices', require './api/notice'
  app.use '/api/activities', require './api/activity'
  app.use '/auth', require './auth'
  app.use '/api/azure_encode_tasks', require './api/azure_encode_task'
  app.use '/api/aodianyuns', require './api/aodianyun'
  app.use '/api/loggers', require './api/logger'
  app.use '/api/banners', require './api/banner'
  app.use '/api/tags', require './api/tag'
  app.use errorHandler

  # All undefined asset or api routes should return a 404
  app.route '/:url(api|auth|components|app|bower_components|assets)/*'
  .get errors[404]

  app.route '/common/Const.js'
  .get (req, res) ->
    res.sendfile __dirname + '/common/Const.js'

  # All other routes should redirect to the index.html
  app.route '/*'
  .get (req, res) ->
    subContext =
      switch true
        when req.url.indexOf('/test') is 0
          '/test'
        when req.url.indexOf('/admin') is 0
          '/admin'
        else
          ''
    indexFile = subContext + '/index.html'
    indexPath = app.get('appPath') + indexFile
    locals =
      initUser: "null"

    # if there is no cookie token, return index.html immediately
    if not req.cookies.token?
      ejs.renderFile indexPath, locals, (err, htmlStr) ->
        if err then return res.render 404

        res.send htmlStr
    else
      logger.info 'refreshing, req.cookies:'
      logger.info req.cookies
      # remove double quote
      token = req.cookies.token.replace /"/g, ''
      jwt.verify token, config.secrets.session, null, (err, user) ->
        logger.info "after verity token, we get user:"
        logger.info user

        unless err?
          locals.initUser = JSON.stringify  _id: user._id

        ejs.renderFile indexPath, locals, (err, htmlStr) ->
          if err then return res.render 404

          res.send htmlStr

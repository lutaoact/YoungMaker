# Main application routes

'use strict'

errors = require './components/errors'
fs = require 'fs'
byline = require 'byline'
jwt = require 'jsonwebtoken'
config = require './config/environment'

errorHandler = (err, req, res, next) ->
  logger.error err
  util = require 'util'
  res.json err.status || 500, util.inspect err

module.exports = (app) ->

  # Insert routes below
  app.use '/api/users', require './api/user'
  app.use '/api/courses', require './api/course'
  app.use '/api/categories', require './api/category'
  app.use '/api/classes', require './api/classe'
  app.use '/api/organizations', require './api/organization'
  app.use '/api/qiniu', require './api/qiniu'
  app.use '/api/assets', require './api/asset'
  app.use '/api/slides', require './api/slide'
  app.use '/api/lectures', require './api/lecture'
  app.use '/api/dis_topics', require './api/dis_topic'
  app.use '/api/dis_replies', require './api/dis_reply'
  app.use '/api/questions', require './api/question'
  app.use '/api/class_progresses', require './api/class_progress'
  app.use '/api/key_points', require './api/key_point'
  app.use '/api/homework_answers', require './api/homework_answer'
  app.use '/api/homework_stats', require './api/homework_stats'
  app.use '/api/quiz_answers', require './api/quiz_answer'
  app.use '/api/quiz_stats', require './api/quiz_stats'
  app.use '/api/lecture_stats', require './api/lecture_stats'
  app.use '/api/keypoint_stats', require './api/keypoint_stats'
  app.use '/api/activities', require './api/activity'
  app.use '/api/progresses', require './api/progress'
  app.use '/api/schools', require './api/school'
  app.use '/api/schedules', require './api/schedule'
  app.use '/api/notices', require './api/notice'
  app.use '/api/offline_works', require './api/offline_work'
  app.use '/api/demo', require './api/demo'
  app.use '/auth', require './auth'
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
    # if there is no cookie token, return index.html immediately
    if not req.cookies.token?
      res.sendfile app.get('appPath') + '/index.html'
    else
      # remove double quote
      token = req.cookies.token.replace /"/g, ''
      jwt.verify token, config.secrets.session, null, (err, user) ->
        if err?
          # console.log 'Cannot verify token'
          # failed to verify token, return index.html
          res.sendfile app.get('appPath') + '/index.html'
        else
          fileString = (fs.readFileSync app.get('appPath') + '/index.html').toString()
          userInfo = """
             ("indexUser" , {
                 "_id": "#{user._id}",
                 "role": "#{user.role}"
             })
          """
          fileString = fileString.replace "('indexUser', null)", userInfo
          res.send fileString

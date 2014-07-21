'use strict'

User = require './user.model'
passport = require 'passport'
config = require '../../config/environment'
jwt = require 'jsonwebtoken'
qiniu = require 'qiniu'
helpers = require '../../common/helpers'
path = require 'path'
_ = require 'lodash'
fs = require 'fs'
http = require 'http'
xlsx = require 'node-xlsx'

qiniu.conf.ACCESS_KEY = config.qiniu.access_key
qiniu.conf.SECRET_KEY = config.qiniu.secret_key
qiniuDomain                       = config.qiniu.domain

validationError = (res, err) ->
  res.json 422, err

###
  Get list of users
  restriction: 'admin'
###
exports.index = (req, res) ->
  User.find {}, '-salt -hashedPassword', (err, users) ->
    res.send 500, err if err
    res.json 200, users

###
  Creates a new user
###
exports.create = (req, res, next) ->
  newUser = new User req.body
  newUser.provider = 'local'
  newUser.save (err, user) ->
    return validationError res, err if err
    token = jwt.sign
      _id: user._id,
      config.secrets.session,
      expiresInMinutes: 60*5
    res.json
     token: token

###
  Get a single user
###
exports.show = (req, res, next) ->
  userId = req.params.id

  User.findById userId, (err, user) ->
    next err if err
    res.send 401 if not user
    res.json user.profile

###
  Deletes a user
  restriction: 'admin'
###
exports.destroy = (req, res) ->
  User.findByIdAndRemove req.params.id, (err, user) ->
    res.send 500, err if err
    res.send 204

###
  Change a users password
###
exports.changePassword = (req, res, next) ->
  userId = req.user._id
  oldPass = String req.body.oldPassword
  newPass = String req.body.newPassword

  User.findById userId, (err, user) ->
    if user.authenticate oldPass
      user.password = newPass
      user.save (err) ->
        validationError res, err if err
        res.send 200
    else
      res.send 403

###
  Get my info
###
exports.me = (req, res, next) ->
  userId = req.user._id
  User.findOne
    _id: userId,
    '-salt -hashedPassword',
    (err, user) -> # donnot ever give out the password or salt
      next err if err
      res.json 401 if not user
      res.json user

###
  Update user
###
exports.update = (req, res) ->

  delete req.body._id if _.has req.body, '_id'
  delete req.body.password if _.has req.body, 'password'

  User.findById req.params.id, (err, user) ->

      return handleError err if err
      return res.send 404 if not user

      updated = _.merge user , req.body
      updated.save (err) ->
        return handleError err if err
        return res.json 200, user

###
  Bulk import users from excel sheet uploaded by client
###
exports.bulkImport = (req, res, next) ->
  resourceKey = req.body.url

  ## create download URL
  baseUrl = qiniu.rs.makeBaseUrl qiniuDomain, resourceKey
  policy = new qiniu.rs.GetPolicy()
  tempUrl = policy.makeRequest baseUrl

  destFile = config.tmpDir + path.sep + 'user_list.xlsx'

  ## download excel sheet and start processing
  file = fs.createWriteStream destFile
  request = http.get tempUrl, (stream) ->
    stream.pipe file
    file.on 'finish', () ->
      file.close () ->
        console.log 'Start parsing file...'
        obj = xlsx.parse destFile

        data = obj.worksheets[0].data

        if not data
          console.error 'Failed to parse user list file or empty file'
          res.send 500
          return

        # real user data starting from second row
        userList = _.rest data

        _.forEach userList, (userItem) ->

          console.log 'UserItem is ...'
          console.log userItem

          newUser = new User
            name : userItem[0].value
            email : userItem[1].value
            role   :  userItem[2].value
            password : userItem[1].value

          newUser.save (err, user) ->
            return validationError res, err if err
            console.log 'Created user ' + userItem[0]

        res.send 200

  .on 'error' , (err) ->
    console.error 'There is an error while downloading file from ' + url
    fs.unlink dest  # delete the file async
    res.send 500


###
 Authentication callback
###
exports.authCallback = (req, res, next) ->
  res.redirect '/'

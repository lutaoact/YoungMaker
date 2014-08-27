'use strict'

User = _u.getModel "user"
Classe = _u.getModel 'classe'
passport = require 'passport'
config = require '../../config/environment'
jwt = require 'jsonwebtoken'
qiniu = require 'qiniu'
path = require 'path'
_ = require 'lodash'
fs = require 'fs'
http = require 'http'
xlsx = require 'node-xlsx'

qiniu.conf.ACCESS_KEY = config.qiniu.access_key
qiniu.conf.SECRET_KEY = config.qiniu.secret_key
qiniuDomain           = config.qiniu.domain

###
  Get list of users
  restriction: 'admin'
###
exports.index = (req, res, next) ->
  User.findQ {}, '-salt -hashedPassword'
  .then (users) ->
    res.send users
  , (err) ->
    next err

###
  Creates a new user
###
exports.create = (req, res, next) ->
  body = req.body
  body.provider = 'local'

  User.createQ body
  .then (user) ->
    token = jwt.sign
      _id: user._id,
      config.secrets.session,
      expiresInMinutes: 60*5
    res.json
      token: token
  , (err) ->
    next err

###
  Get a single user
###
exports.show = (req, res, next) ->

  userId = req.params.id

  User.findByIdQ userId
  .then (user) ->
    res.send user.profile
  , (err) ->
    next err

###
  Get a single user by email
###
exports.showByEmail = (req, res, next) ->
  User.findOneQ
    email : req.params.email
  .then (user) ->
    return res.send 404 if not user?
    res.send user.profile
  , (err) ->
    next err

###
  Deletes a user
  restriction: 'admin'
###
exports.destroy = (req, res, next) ->
  User.findByIdAndRemoveQ req.params.id
  .then (user) ->
    res.send user
  , (err) ->
    next err

###
  Change a users password
###
exports.changePassword = (req, res, next) ->
  userId = req.user._id
  oldPass = String req.body.oldPassword
  newPass = String req.body.newPassword

  User.findByIdQ userId
  .then (user) ->
    if user.authenticate oldPass
      user.password = newPass
      user.save (err) ->
        return next err if err
        res.send 200
    else
      res.send 403
  , (err) ->
    next err


###
  Get my info
###
exports.me = (req, res, next) ->
  userId = req.user.id
  User.findOneQ
    _id: userId
    '-salt -hashedPassword'
  .then (user) -> # donnot ever give out the password or salt
    return res.send 401 if not user?
    res.send user
  , (err) ->
    next err

###
  Update user
###
exports.update = (req, res, next) ->

  delete req.body._id if req.body._id?
  delete req.body.password if req.body.password?

  User.findByIdQ req.params.id
  .then (user) ->
    return res.send 404 if not user?

    updated = _.merge user , req.body
    updated.saveQ()
  .then (user) ->
    res.send user
  , (err) ->
    next err


updateClasseStudents = (res, next, classeId, studentList, importReport) ->
  Classe.findByIdQ classeId
  .then (classe) ->
    return res.send 404 if not classe?

    logger.info 'Found classe with id '

    classe.students = _.merge classe.students, studentList
    classe.markModified 'students'
    logger.info 'After merge, classe is: ' + classe

    classe.saveQ()
  .then (saved) ->
    res.send importReport
  , (err) ->
    next err


###
  Bulk import users from excel sheet uploaded by client
###
exports.bulkImport = (req, res, next) ->
  resourceKey = req.body.key
  orgId = req.body.orgId
  type = req.body.type
  classeId = req.body.classeId

  # do some sanity check
  if not type? then return res.send 400
  if not orgId? then return res.send 400
  if type is 'student' and not classeId? then return res.send 400

  ## create download URL
  baseUrl = qiniu.rs.makeBaseUrl qiniuDomain, resourceKey
  policy = new qiniu.rs.GetPolicy()
  tempUrl = policy.makeRequest baseUrl

  destFile = config.local.tempDir + path.sep + 'user_list.xlsx'

  ## download excel sheet and start processing
  file = fs.createWriteStream destFile

  request = http.get tempUrl, (stream) ->
    stream.pipe file
    file.on 'finish', () ->
      file.close () ->
        console.log 'Start parsing file...'
        obj = xlsx.parse destFile

        userList = obj.worksheets[0].data

        if not userList
          console.error 'Failed to parse user list file or empty file'
          return res.send 500

        importReport =
          total : 0
          success : []
          failure : []

        importedUser = []

        savePromises = _.map userList, (userItem) ->

          console.log 'UserItem is ...'
          console.dir userItem

          newUser = new User
            name : userItem[0].value
            email : userItem[1].value
            role   :  type
            password : userItem[1].value #initial password is the same as email
            orgId : orgId

          newUser.saveQ()

        Q.allSettled(savePromises)
        .then (results) ->
          _.forEach results, (result) ->
            if result.state is 'fulfilled'
              user = result.value
              console.log 'Imported user ' + user.name
              importReport.success.push user.name
              importedUser.push user.id
            else
              console.error 'Failed to import user ' + user.name
              importReport.failure.push result.reason

          if type is 'student'
            updateClasseStudents res, next, classeId, importedUser, importReport
          else
            res.send importReport
        , (err) ->
          next err

  .on 'error' , (err) ->
    console.error 'There is an error while downloading file from ' + url
    fs.unlink dest  # delete the file async
    next err


exports.forget = (req, res, next) ->
  if not req.body.email? then return res.send 400

  crypto = require 'crypto'
  cryptoQ = Q.nbind(crypto.randomBytes)

  cryptoQ(21)
  .then (buf) ->
    token = buf.toString 'hex'
    conditions =
      email: req.body.email.toLowerCase()
    fieldsToSet =
      resetPasswordToken: token,
      resetPasswordExpires: Date.now() + 10000000
    User.findOneAndUpdateQ conditions, fieldsToSet
  .then (user) ->
    options =
      from: req.app.config.smtp.from.name+' <'+req.app.config.smtp.from.address+'>'
      to: user.email
      subject: 'Reset your '+req.app.config.projectName+' password'
      textPath: 'users/forgot/email-text'
      htmlPath: 'users/forgot/email-html'
      locals:
        username: user.name
        resetLink: req.protocol+'://'+req.headers.host+'/login/reset/'+user.email+'/'+token+'/'
        projectName: req.app.config.projectName
      success: (message) ->
        res.send 201
      error: (err) ->
        res.json(404, err)

    req.app.utility.sendmail(req, res, options)

  , (err) ->
    next err


exports.reset = (req, res, next) ->
  if not req.body.password? then return res.send 400

  User.findOneQ
    email: req.params.email.toLowerCase()
    resetPasswordToken: req.params.token
    resetPasswordExpires:
      $gt: Date.now()
  .then (user) ->
    return res.send 404 if not user?
    user.password = req.body.password
    user.saveQ()
  .then (saved) ->
    res.send 200
  , (err) ->
    next err

###
 Authentication callback
###
exports.authCallback = (req, res, next) ->
  res.redirect '/'

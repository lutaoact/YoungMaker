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
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

qiniu.conf.ACCESS_KEY = config.qiniu.access_key
qiniu.conf.SECRET_KEY = config.qiniu.secret_key
qiniuDomain           = config.assetsConfig[config.assetHost.uploadFileType].domain

###
  Get list of users
  restriction: 'admin'
###
exports.index = (req, res, next) ->
  
  User.findQ 
    orgId : req.user.orgId
  , '-salt -hashedPassword'
  .then (users) ->
    res.send users
  , next

###
  Creates a new user
###
exports.create = (req, res, next) ->
  body = req.body
  body.provider = 'local'

  delete body._id
  body.orgId = req.user.orgId

  User.createQ body
  .then (user) ->
    token = jwt.sign
      _id: user._id,
      config.secrets.session,
      expiresInMinutes: 60*5
    res.json
      _id: user._id
      token: token
  , next

###
  Get a single user
###
exports.show = (req, res, next) ->

  userId = req.params.id

  User.findByIdQ userId
  .then (user) ->
    res.send user.profile
  , next

###
  Get a single user by email
###
exports.showByEmail = (req, res, next) ->
  User.findOneQ
    email : req.params.email
  .then (user) ->
    return res.send 404 if not user?
    res.send user.profile
  , next

###
  Deletes a user
  restriction: 'admin'
###
exports.destroy = (req, res, next) ->
  userId = req.params.id
  userObj = undefined
  User.removeQ
    orgId: req.user.orgId
    _id: userId
  .then (user) ->
    userObj = user
    Classe.findOneQ
      students : userId
  .then (classe) ->
    if classe?
      classe.updateQ
        $pull :
          students : userId
  .then (classe) ->
    res.send userObj
  , next

exports.multiDelete = (req, res, next) ->
  ids = req.body.ids
  User.removeQ
    orgId: req.user.orgId
    _id: $in: ids
  .then () ->
    res.send 204
  , next

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
  , next


###
  Get my info
###
exports.me = (req, res, next) ->
  userId = req.user._id
  User.findOne
    _id: userId
    '-salt -hashedPassword'
  .populate 'orgId'
  .execQ()
  .then (user) -> # donnot ever give out the password or salt
    return res.send 401 if not user?
    res.send user
  , next

###
  Update user
###
exports.update = (req, res, next) ->
  body = req.body
  body = _.omit body, ['_id', 'password', 'orgId', 'username']

  User.findByIdQ req.params.id
  .then (user) ->
    return res.send 404 if not user?

    updated = _.merge user , req.body
    updated.saveQ()
  .then (result) ->
    res.send result[0]
  , next


updateClasseStudents = (res, next, classeId, studentList, importReport) ->
  Classe.findByIdQ classeId
  .then (classe) ->
    return res.send 404 if not classe?

    logger.info 'Found classe with id ' + classe.id
    classe.students = _.union classe.students, studentList
    classe.markModified 'students'
    classe.saveQ()
  .then (result) ->
    res.send importReport
  , next


###
  Bulk import users from excel sheet uploaded by client
###
exports.bulkImport = (req, res, next) ->
  console.log 'start importing...'
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

        importedUsers = []

        savePromises = _.map userList, (userItem) ->

          newUser = new User.model
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
              user = result.value[0]
              console.log 'Imported user ' + user.name
              importReport.success.push user.name
              importedUsers.push user.id
            else
              console.error 'Failed to import user ' + user.name
              importReport.failure.push result.reason

          if type is 'student'
            updateClasseStudents res, next, classeId, importedUsers, importReport
          else
            res.send importReport
        , next

  .on 'error' , (err) ->
    console.error 'There is an error while downloading file from ' + url
    fs.unlink dest  # delete the file async
    next err


exports.forget = (req, res, next) ->
  if not req.body.email? then return res.send 400

  crypto = require 'crypto'
  cryptoQ = Q.nbind(crypto.randomBytes)
  token = null

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
    sendPwdResetMail = require('../../common/mail').sendPwdResetMail
    resetLink = req.protocol+'://'+req.headers.host+'/accounts/resetpassword?email='+user.email+'&token='+token
    sendPwdResetMail user.name, user.email, resetLink
  .done () ->
    res.send 200
  , next


exports.reset = (req, res, next) ->
  if not req.body.password? then return res.send 400

  User.findOneQ
    email: req.query.email.toLowerCase()
    resetPasswordToken: req.query.token
    resetPasswordExpires:
      $gt: Date.now()
  .then (user) ->
    return res.send 404 if not user?
    user.password = req.body.password
    user.saveQ()
  .then (saved) ->
    res.send 200
  , next

###
 Authentication callback
###
exports.authCallback = (req, res, next) ->
  res.redirect '/'

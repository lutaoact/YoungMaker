'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
crypto = require 'crypto'
authTypes = ['google']
BaseModel = require '../../common/BaseModel'

class User extends BaseModel
  schema: new Schema
    email:#用于登录
      type: String
      lowercase: true
      unique: true
      required: true
    hashedPassword:
      type: String
    salt:
      type: String
    avatar:
      type: String
    info:
      type: String
    name:#真实姓名
      type: String
    weibo:
      id: String
      name: String
      token: String
    qq:
      id: String
      name: String
      token: String
    canManage:
      type: Boolean
      default: false
    canPub:
      type: Boolean
      default: false
    resetPasswordToken:
      type: String
    resetPasswordExpires:
      type: Date

  constructor: ->
    @setupUserSchema @schema
    super

  findBy: (userInfo) ->
    conditions = {$or: []}
    conditions.$or.push(email   : userInfo.email)    if userInfo.email?

    if _.isEmpty conditions.$or
      return Q.reject
        status: 400
        errCode: ErrCode.IllegalFields
        errMsg: 'email字段不能为空'

    @findOneQ conditions

  setupUserSchema: (UserSchema) ->
    UserSchema
    .virtual 'password'
    .set (password) ->
      this._password = password
      this.salt = this.makeSalt()
      this.hashedPassword = this.encryptPassword(password)
    .get () ->
      this._password

    # Public profile information
    UserSchema
    .virtual 'profile'
    .get () ->
      '_id': this._id
      'name': this.name
      'info': this.info
      'email': this.email
      'avatar': this.avatar

    # Non-sensitive info we will be putting in the token
    UserSchema
    .virtual 'token'
    .get () ->
      '_id': this._id

    # Validate empty email
    UserSchema
    .path 'email'
    .validate (email) ->
      email.length
    , '邮箱地址不能为空'

    # Validate empty password
    UserSchema
    .path 'hashedPassword'
    .validate (hashedPassword) ->
      hashedPassword.length
    , '登录密码不能为空'

    # Validate email is not taken
    UserSchema
    .path 'email'
    .validate (value, respond) ->
      self = this
      this.constructor.findOne
        email: value
      , (err, user) ->
        throw err if err
        notTaken = !user or user.id == self.id
        respond notTaken
    , '该邮箱地址已经被占用，请选择其他邮箱'

    validatePresenceOf = (value) ->
      value && value.length

    UserSchema
    .pre 'save', (next) ->
      if not this.isNew
        next()
      if not validatePresenceOf(this.hashedPassword)
        next new Error 'Invalid password'
      else
        next()

    UserSchema.methods =
      ###
        Authenticate - check if the passwords are the same
        @param {String} plainText
        @return {Boolean}
        @api public
      ###
      authenticate: (plainText) ->
        this.encryptPassword(plainText) is this.hashedPassword

      ###
        Make salt
        @return {String}
        @api public
      ###
      makeSalt: () ->
        crypto.randomBytes 16
        .toString 'base64'

      ###
        Encrypt password
        @param {String} password
        @return {String}
        @api public
      ###
      encryptPassword: (password) ->
        '' if  not password or not this.salt
        salt = new Buffer this.salt, 'base64'
        crypto.pbkdf2Sync password, salt, 10000, 64
        .toString 'base64'

exports.Class = User
exports.Instance = new User()

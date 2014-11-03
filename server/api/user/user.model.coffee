'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
crypto = require 'crypto'
authTypes = ['google']
BaseModel = require '../../common/BaseModel'

class User extends BaseModel
  schema : new Schema
    avatar :
      type : String
    username :
      type : String
      unique: true
      required: true
    email :
      type : String
      lowercase : true
      unique: true
      sparse: true
    info :
      type : String
    name :
      type : String
    hashedPassword :
      type : String
    provider :
      type : String
    role :
      type : String
      default : 'student'
    salt :
      type : String
    resetPasswordToken :
      type: String
    resetPasswordExpires :
      type: Date

  constructor : ->
    @setupUserSchema @schema
    super

  setupUserSchema : (UserSchema) ->
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
      'role': this.role
      'info': this.info
      'email': this.email
      'avatar': this.avatar
      'username': this.username

    # Non-sensitive info we will be putting in the token
    UserSchema
    .virtual 'token'
    .get () ->
      '_id': this._id
      'role': this.role

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

    # Validate username is not taken
    UserSchema
    .path 'username'
    .validate (value, respond) ->
      self = this
      this.constructor.findOne
        username: value
      , (err, user) ->
        throw err if err
        notTaken = !user or user.id == self.id
        respond notTaken
    , '该用户名已经被占用，请选择其他用户名'

    validatePresenceOf = (value) ->
      value && value.length

    UserSchema
    .pre 'save', (next) ->
      if not this.isNew
        next()
      if not validatePresenceOf(this.hashedPassword) and authTypes.indexOf(this.provider) is -1
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

exports.Instance = new User()

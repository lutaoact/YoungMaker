'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin

crypto = require 'crypto'

UserSchema = new Schema
  avatar :
    type : String
  email :
    type : String
    lowercase : true
  name :
    type : String
  org_id :
    type : ObjectId
  hashed_password :
    type : String
  provider :
    type : String
  role :
    type : String
    default : 'student'
  salt :
    type : String
  status :
    type : String

UserSchema.plugin createdModifiedPlugin

###
Virtuals
###
UserSchema
  .virtual 'password'
  .set (password) ->
    this._password = password
    this.salt = this.makeSalt()
    this.hashed_password = this.encryptPassword(password)
  .get () ->
    this._password

# Public profile information
UserSchema
  .virtual 'profile'
  .get () ->
      'name': this.name
      'role': this.role
      'avatar' : this.avatar

# Non-sensitive info we will be putting in the token
UserSchema
  .virtual 'token'
  .get () ->
      '_id': this._id
      'role': this.role

###
  Validations
###

# Validate empty email
UserSchema
  .path 'email'
  .validate (email) ->
    email.length
  , 'Email cannot be blank'

# Validate empty password
UserSchema
  .path 'hashed_password'
  .validate (hashed_password) ->
    hashed_password.length
  , 'Password cannot be blank'

# Validate email is not taken
UserSchema
  .path 'email'
  .validate (value, respond) ->
    self = this
    this.constructor.findOne
      email: value
    , (err, user) ->
      throw err if err
      if user
        if self.id is user.id
          respond true
        respond false
      respond true
, 'The specified email address is already in use.'

validatePresenceOf = (value) ->
  value && value.length

###
  Pre-save hook
###
UserSchema
  .pre 'save', (next) ->
    if  not this.isNew
      next()

    if not validatePresenceOf(this.hashed_password) and authTypes.indexOf(this.provider) is -1
      next new Error 'Invalid password'
    else
      next()

###
  Methods
###
UserSchema.methods =
  ###
    Authenticate - check if the passwords are the same
    @param {String} plainText
    @return {Boolean}
    @api public
  ###
  authenticate: (plainText) ->
    this.encryptPassword(plainText) is this.hashed_password

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

module.exports = mongoose.model 'User', UserSchema

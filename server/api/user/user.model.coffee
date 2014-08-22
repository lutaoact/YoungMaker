'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

#createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin

crypto = require 'crypto'

authTypes = ['google']

BaseModel = (require '../../common/BaseModel').BaseModel

exports.User = BaseModel.subclass
  classname: 'User'
  initialize: ($super) ->
    @schema = new Schema
      avatar :
        type : String
      email :
        type : String
        lowercase : true
      name :
        type : String
      orgId :
        type : ObjectId
        ref : 'organization'
      hashedPassword :
        type : String
      provider :
        type : String
      role :
        type : String
        default : 'student'#TODO change role to Number
      salt :
        type : String
      status :
        type : String
      resetPasswordToken :
        type: String
      resetPasswordExpires :
        type: Date

    setupUserSchema @schema

    $super()

#UserSchema = new Schema
#  avatar :
#    type : String
#  email :
#    type : String
#    lowercase : true
#  name :
#    type : String
#  hashedPassword :
#    type : String
#  provider :
#    type : String
#  role :
#    type : String
#    default : 'employee'
#  salt :
#    type : String
#  status :
#    type : String
#  resetPasswordToken :
#    type: String
#  resetPasswordExpires :
#    type: Date


###
Virtuals
###
setupUserSchema = (UserSchema) ->
#  UserSchema.plugin createdModifiedPlugin
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
    'name': this.name
    'role': this.role
    'avatar' : this.avatar

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
  , 'Email cannot be blank'

  # Validate empty password
  UserSchema
  .path 'hashedPassword'
  .validate (hashedPassword) ->
    hashedPassword.length
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
          return respond true
        return respond false
      return respond true
  , 'The specified email address is already in use.'

  validatePresenceOf = (value) ->
    value && value.length

  UserSchema
  .pre 'save', (next) ->
    if  not this.isNew
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

#module.exports = mongoose.model 'User', UserSchema

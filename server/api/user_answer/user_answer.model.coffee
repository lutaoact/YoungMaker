'use strict'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require('../../common/BaseModel').BaseModel

exports.UserAnswer = BaseModel.subclass
  classname: 'UserAnswer'
  initialize: ($super) ->
    @schema = new Schema
      questionId :
        type : ObjectId
        required : true
        ref : 'question'
      userId :
        type : ObjectId
        required : true
        ref : 'user'
      result : [ Number ]
        # For choice questions, element should be numbers starting from 0
        # for example: [0, 3]

    $super()


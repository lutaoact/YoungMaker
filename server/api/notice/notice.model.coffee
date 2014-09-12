'use strict'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require('../../common/BaseModel').BaseModel

exports.Notice = BaseModel.subclass
  classname: 'Notice'
  initialize: ($super) ->
      @schema = new Schema
        userId:
          type: ObjectId
          ref: 'user'
          required: true
        fromWhom:
          type: ObjectId
          ref: 'user'
        type: Number
        data:
          lectureId:
             type: ObjectId
             ref: 'lecture'
          discussionId:
             type: ObjectId
             ref: 'discussion'
        status: Number

      $super()

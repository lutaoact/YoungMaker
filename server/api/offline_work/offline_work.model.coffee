'use strict'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require('../../common/BaseModel').BaseModel

exports.OfflineWork = BaseModel.subclass
  classname: 'OfflineWork'
  initialize: ($super) ->
    @schema = new Schema
      userId:
        type: ObjectId
        ref: 'user'
        required: true
      lectureId:
        type: ObjectId
        ref: 'lecture'
        required: true
      files: [{
        name: String
        url: String
        size: Number
        }]
      desc: String
      teacherId:
        type: ObjectId
        ref: 'user'
      score: Number
      feedback: String
      submitted: Boolean

    $super()

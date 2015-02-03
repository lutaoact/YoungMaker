'use strict'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require('../../common/BaseModel')

class Notice extends BaseModel
  schema: new Schema
    userId:
      type: ObjectId
      ref: 'user'
      required: true
    fromWhom:
      type: ObjectId
      ref: 'user'
    type: Number
    data:
      lecture:
         type: ObjectId
         ref: 'lecture'
      disTopic:
         type: ObjectId
         ref: 'dis_topic'
      disReply:
         type: ObjectId
         ref: 'dis_reply'
    status: Number

exports.Class = Notice
exports.Instance = new Notice()

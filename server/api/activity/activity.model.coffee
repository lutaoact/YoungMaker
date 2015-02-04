"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel')

class Activity extends BaseModel
  populates:
    index: [
      path: 'userId', select: 'name avatar'
    ]
  schema: new Schema
    userId:
      type: ObjectId
      ref: 'user'
      required: true
    title:
      type: String
      required: true
    type:
      type: Number
      required: true
    objectId:
      type: ObjectId
      required: true

exports.Class = Activity
exports.Instance = new Activity()

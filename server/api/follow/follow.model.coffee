"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel')

class Follow extends BaseModel
  schema: new Schema
    from:
      type: ObjectId
      ref: 'user'
      required: true
    to:
      type: ObjectId
      ref: 'user'
      required: true

exports.Class = Follow
exports.Instance = new Follow()

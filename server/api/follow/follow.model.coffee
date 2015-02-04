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
      index: true
    to:
      type: ObjectId
      ref: 'user'
      required: true
      index: true

  constructor: ->
    @schema.index {from: 1, to: 1}, {unique: true}
    super

exports.Class = Follow
exports.Instance = new Follow()

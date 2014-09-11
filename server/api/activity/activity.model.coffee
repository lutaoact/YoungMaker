"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Activity = BaseModel.subclass
  classname: 'Activity'
  initialize: ($super) ->
    @schema = new Schema
      userId:
        type: ObjectId
        ref: 'user'
        required: true
      eventType:
        type: Number
        required: true
      data: {}

    $super()

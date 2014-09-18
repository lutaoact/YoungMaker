"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Schedule = BaseModel.subclass
  classname: 'Schedule'
  initialize: ($super) ->
    @schema = new Schema
      course:
        type: Schema.Types.ObjectId
        ref: "course"
        required: true
      classe:
        type: Schema.Types.ObjectId
        ref: "classe"
        required: true
      start:
        type: Date
        required: true
      end:
        type: Date
        required: true
      until:
        type: Date
        required: true

    $super()

"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Schedule = BaseModel.subclass
  classname: 'Schedule'
  initialize: ($super) ->
    @schema = new Schema
      courseId:
        type: Schema.Types.ObjectId
        ref: "course"
        required: true
      classeId:
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

    @schema.index {courseId: 1, classeId: 1}, {unique: true}

    $super()

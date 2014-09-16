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
      classeId:
        type: Schema.Types.ObjectId
        ref: "classe"
      start: Date
      end: Date
      until: Date

    $super()

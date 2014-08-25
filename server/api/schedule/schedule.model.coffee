"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Schedule = BaseModel.subclass
  classname: 'Schedule'
  initialize: ($super) ->
    @schema = new Schema
      classeId:
        type: Schema.Types.ObjectId
        ref: 'classe'
      courseId:
        type: Schema.Types.ObjectId
        ref: "course"
      data: Schema.Types.Mixed

    $super()

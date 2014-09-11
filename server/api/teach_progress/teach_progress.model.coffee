"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.TeachProgress = BaseModel.subclass
  classname: 'TeachProgress'
  initialize: ($super) ->
    @schema = new Schema
      userId:
        type: ObjectId
        ref: 'user'
        required: true
      classeId:
        type: ObjectId
        ref: 'classe'
        required: true
      courseId:
        type: ObjectId
        ref: 'course'
        required: true
      progress: [
        type: Schema.Types.ObjectId
        ref: "lecture"
      ]

    $super()

"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.LearnProgress = BaseModel.subclass
  classname: 'LearnProgress'
  initialize: ($super) ->
    @schema = new Schema
      userId:
        type: ObjectId
        ref: 'user'
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

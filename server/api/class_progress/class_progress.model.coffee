# TODO: does lecturesStatus need _id?; change type to Mix, use dict instead;

#name: String,
"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.ClassProgress = BaseModel.subclass
  classname: 'ClassProgress'
  initialize: ($super) ->
    @schema = new Schema
      userId:
        type: Schema.Types.ObjectId
        ref: "User"
      courseId:
        type: Schema.Types.ObjectId
        ref: "Course"
      classId:
        type: Schema.Types.ObjectId
        ref: "Class"
      lecturesStatus: [
        lectureId:
          type: Schema.Types.ObjectId
          ref: "Lecture"
        isFinished: Boolean
      ]
      timeTable: [
        name: String
        time: Date
      ]
    $super()

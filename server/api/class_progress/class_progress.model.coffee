# TODO: does lecturesStatus need _id?; change type to Mix, use dict instead;

#name: String,
"use strict"

mongoose = require("mongoose")
createdModifiedPlugin = require("mongoose-createdmodified").createdModifiedPlugin
Schema = mongoose.Schema

ClassProgressSchema = new Schema(
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
)
ClassProgressSchema.plugin createdModifiedPlugin,
  index: true

module.exports = mongoose.model("ClassProgress", ClassProgressSchema)

## sourceMappingURL=thing.model.js.map

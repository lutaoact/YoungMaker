"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Lecture = BaseModel.subclass
  classname: 'Lecture'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      courseId:
        type: Schema.Types.ObjectId
        required: true
        ref: "Course"
      thumbnail: String
      info: String
      slides: [
        thumb: String
      ]
      knowledgePoints: [
        type: Schema.Types.ObjectId
        ref: "KnowledgePoint"
      ]
      # TODO: define Quesiton DB
#      questions: {type: Schema.Types.ObjectId, ref: 'Question'}

    $super()

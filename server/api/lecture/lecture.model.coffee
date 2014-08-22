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
      thumbnail: String
      info: String
      slides: [
        thumb: String
        raw: String
      ]
      media: String
      knowledgePoints: [
        type: Schema.Types.ObjectId
        ref: "knowledge_point"
      ]
      quizs: [
        type: Schema.Types.ObjectId
        ref: "question"
      ]
      homeworks: [
        type: Schema.Types.ObjectId
        ref: "question"
      ]

    $super()

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
      files: [
        fileName: String
        fileContent: [
          thumb: String
          raw: String
        ]
      ]
      slides: [
        thumb: String
        raw: String
      ]
      media: String
      encodedMedia: String
      keyPoints: [
        kp :
          type: Schema.Types.ObjectId
          ref : "key_point"
        timestamp: Number
      ]
      quizzes: [
        type: Schema.Types.ObjectId
        ref: "question"
      ]
      homeworks: [
        type: Schema.Types.ObjectId
        ref: "question"
      ]

    $super()

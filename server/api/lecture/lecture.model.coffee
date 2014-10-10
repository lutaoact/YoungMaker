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
      accessPolicyId: String # for azure media service
      locatorId: String # for azure media service
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

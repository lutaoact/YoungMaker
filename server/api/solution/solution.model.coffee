"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Solution = BaseModel.subclass
  classname: 'Solution'
  initialize: ($super) ->
    @schema = new Schema
      question_id: String
      content: String
      keyPoints: String
      course:
        type: Schema.Types.ObjectId
        ref: 'course'

    $super()

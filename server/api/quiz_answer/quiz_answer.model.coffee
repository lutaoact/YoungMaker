"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.QuizAnswer = BaseModel.subclass
  classname: 'QuizAnswer'
  initialize: ($super) ->
    @schema = new Schema
      userId :
        type : ObjectId
        required : true
        ref : 'user'
      lectureId :
        type : ObjectId
        required : true
        ref : 'lecture'
      questionId :
        type : ObjectId
        required : true
        ref : 'question'
      result : [
        Schema.Types.Mixed
        # For choice questions, element should be numbers starting from 0
        # for example: [0, 3]
      ]

    $super()

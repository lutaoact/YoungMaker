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
      result :
        type : Schema.Types.Mixed
        default : {}
        required : true

    $super()

"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.HomeworkAnswer = BaseModel.subclass
  classname: 'HomeworkAnswer'
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
      result : [
        questionId : ObjectId
        answer : Schema.Types.Mixed
        # for example: [0, 3]
      ]
      submitted : Boolean

    $super()


  getByLectureId: (lectureId) ->
    return @findQ lectureId: lectureId

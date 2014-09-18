"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.QuizAnswer = BaseModel.subclass
  classname: 'QuizAnswer'
  initialize: ($super) ->
    @schema = new Schema
      lectureId :
        type : ObjectId
        required : true
        ref : 'lecture'
      questionId :
        type : ObjectId
        required : true
        ref : 'question'
      userId :
        type : ObjectId
        required : true
        ref : 'user'
      result : [
        Schema.Types.Mixed
        # For choice questions, element should be numbers starting from 0
        # for example: [0, 3]
      ]

    $super()

  getByLectureIdAndQuestionIds: (lectureId, questionIds) ->
    return @findQ {lectureId: lectureId, questionId: {$in: questionIds}}

  createNewAnswers: (userIds, lectureId, questionId) ->
    datas = for userId in userIds
      lectureId: lectureId
      questionId: questionId
      userId: userId
      result: []

    @createQ datas
    .then (result) ->
      #由于datas所含元素个数的不同，会导致返回的result不同
      #datas若为空数组，则result为undefined
      #datas若只包含一个元素，则result为一个对象
      #datas若超过一个元素，则result为一个数组
      unless result? then return []
      unless _.isArray result then return [result]

      return result

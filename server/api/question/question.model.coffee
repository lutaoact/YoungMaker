"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Question = BaseModel.subclass
  classname: 'Question'
  initialize: ($super) ->
    @schema = new Schema
      orgId:
        type: Schema.Types.ObjectId
        ref: "organization"
      categoryId:
        type: Schema.Types.ObjectId
        ref: "category"
      keyPoints : [
        type: Schema.Types.ObjectId
        ref: "key_point"
      ]
      body: String #题干
      type: Number #1:choice 2:fill blank
      options: [
        choice: String
        correct: Boolean
      ]
      solution: String #填空题的答案
      detailSolution:
        type: String #详解
        required: true
      deleteFlag:
        type: Boolean
        default: false

    $super()

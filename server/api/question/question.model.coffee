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
      content: Schema.Types.Mixed
      type: Number
      solution: String

    $super()

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
      content: Schema.Types.Mixed
#        imageUrl: String
#        title: String
#        body: [
#          desc: String
#          correct: Bool
#        ]
      type: Number #1:choice
      solution: String
      delete_flag:
        type: Boolean
        default: false

    $super()

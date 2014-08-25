"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.KnowledgePoint = BaseModel.subclass
  classname: 'KnowledgePoint'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
        unique: true
      categoryId:
        type: Schema.Types.ObjectId
        ref: "category"

    $super()

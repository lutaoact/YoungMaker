"use strict"

mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Category = BaseModel.subclass
  classname: 'Category'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
        unique: true
      orgId:
        type : ObjectId
        required: true
        ref : 'organization'

    $super()

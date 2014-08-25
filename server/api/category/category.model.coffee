"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Category = BaseModel.subclass
  classname: 'Category'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
        unique: true

    $super()

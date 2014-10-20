'use strict'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require('../../common/BaseModel').BaseModel

exports.InvertIndex = BaseModel.subclass
  classname: 'InvertIndex'
  initialize: ($super) ->
    @schema = new Schema({
      name: String
    })

    $super()


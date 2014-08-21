"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Organization = BaseModel.subclass
  classname: 'Organization'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      logo: String
      subDomain: String
      background: String # url
      type: String

    $super()

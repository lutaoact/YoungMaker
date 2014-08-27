"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Organization = BaseModel.subclass
  classname: 'Organization'
  initialize: ($super) ->
    @schema = new Schema
      uniqueName:
        type : String
        required : true
        unique : true
      name:
        type: String
        required: true
      type:
        type: String
        required : true
      logo: String
      description : String # url

    $super()

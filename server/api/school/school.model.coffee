"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.School = BaseModel.subclass
  classname: 'School'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      majors: [
        name: String
        desc: String
        detail: String
      ]
      institues: [
        name: String
        detail: String
      ]
      leaders: [
        desc: String
        detail: String
      ]
      histories: [
        year: String
        desc: String
      ]

    $super()

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
      overview: [
        desc: String
      ]
      majors: [
        name: String
        desc: String
        detail: String
        picUrl: String
      ]
      institues: [
        name: String
        detail: String
      ]
      leaders: [
        desc: String
        detail: String
        picUrlIndex: String
        picUrlDetail: String
      ]
      histories: [
        year: String
        desc: String
      ]

    $super()

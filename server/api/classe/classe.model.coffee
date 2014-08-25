"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Classe = BaseModel.subclass
  classname: 'Classe'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      orgId:
        type: Schema.Types.ObjectId
        ref: "organization"
      students: [
        type: Schema.Types.ObjectId
        ref: "user"
      ]
      yearGrade: String

    $super()

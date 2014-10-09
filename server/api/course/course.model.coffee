"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Course = BaseModel.subclass
  classname: 'Course'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      categoryId:
        type: Schema.Types.ObjectId
        ref: "category"
      thumbnail: String
      info: String
      lectureAssembly: [
        type: Schema.Types.ObjectId
        ref: "lecture"
      ]
      owners: [
        type: Schema.Types.ObjectId
        ref: "user"
      ]
      classes: [
        type: Schema.Types.ObjectId
        ref: "classe"
      ]
      public:
        type: Boolean
        default: false
    $super()

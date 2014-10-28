"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.UserLectureNote = BaseModel.subclass
  classname: 'UserLectureNote'
  initialize: ($super) ->
    @schema = new Schema
      userId:
        type: ObjectId
        required: true
        ref: 'user'
      lectureId:
        type: ObjectId
        required: true
        ref: 'lecture'
      note: String

    @schema.index {userId : 1, lectureId: 1}, {unique : true}

    $super()

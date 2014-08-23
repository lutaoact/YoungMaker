'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Discussion = BaseModel.subclass
  classname: 'Discussion'
  initialize: ($super) ->
    @schema = new Schema
      userId:
        type: ObjectId
        ref: 'user'
        required: true
      courseId:
        type: ObjectId
        ref: 'course'
        required: true
      lectureId:
        type: ObjectId
        ref: 'lecture'
        required: true
      content:
        type: String
        required: true
      responseTo:
        type: ObjectId
        ref: 'discussion'
      voteUpUsers:[
        type: ObjectId
        ref: 'user'
      ]
      voteDownUsers:[
        type: ObjectId
        ref: 'user'
      ]
    $super()

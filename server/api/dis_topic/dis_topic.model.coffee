'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.DisTopic = BaseModel.subclass
  classname: 'DisTopic'
  initialize: ($super) ->
    @schema = new Schema
      postBy:
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
      title:
        type: String
        required: true
      content:
        type: String
        required: true
      metadata: Schema.Types.Mixed
#        images: [
#          type: String
#        ]
#        tags: [
#          type: String
#        ]
      repliesNum:
        type: Number
        required: true
        default: 0
      viewers: [
        type: ObjectId
        ref: 'user'
      ]
      voteUpUsers: [
        type: ObjectId
        ref: 'user'
      ]
    $super()

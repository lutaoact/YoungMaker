'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require '../../common/BaseModel'

class DisTopic extends BaseModel
  schema: new Schema
    postBy:
      type: ObjectId
      ref: 'user'
      required: true
    disTopicId:
      type: ObjectId
      ref: 'dis_topic'
      required: true
    content:
      type: String
      required: true
    metadata: Schema.Types.Mixed
#      images: [
#        type: String
#      ]
#      tags: [
#        type: String
#      ]
    voteUpUsers: [
      type: ObjectId
      ref: 'user'
    ]

exports.Class = DisTopic
exports.Instance = new DisTopic()

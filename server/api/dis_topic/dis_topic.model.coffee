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
    classe:
      type: ObjectId
      ref: 'classe'
      required: true
    title:
      type: String
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

exports.Class = DisTopic
exports.Instance = new DisTopic()

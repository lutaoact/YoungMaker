'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require '../../common/BaseModel'

class Article extends BaseModel
  schema: new Schema
    title:
      type: String
      required: true
    content:
      type: String
      required: true
    author:
      type: ObjectId
      ref: 'user'
      required: true
    commentsNum:
      type: Number
      required: true
      default: 0
    viewers: [
      type: ObjectId
      ref: 'user'
    ]
    likeUsers: [
      type: ObjectId
      ref: 'user'
    ]
    tags: [
      type: String
    ]

exports.Class = Article
exports.Instance = new Article()

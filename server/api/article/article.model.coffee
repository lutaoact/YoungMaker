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
    author:
      type: ObjectId
      ref: 'user'
      required: true
    commentsNum:
      type: Number
      required: true
      default: 0
    viewersNum:
      type: Number
      required: true
      default: 0
    likeUsers: [
      type: ObjectId
      ref: 'user'
    ]
    tags: [
      type: String
    ]
    pubAt:
      type: Date
      index: true
      sparse: true
    deleteFlag:
      type: Boolean
      default: false


exports.Class = Article
exports.Instance = new Article()

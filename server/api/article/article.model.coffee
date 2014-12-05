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
    viewers:
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
    deleteFlag:
      type: Boolean
      default: false

  getAll: () ->
    return @findQ {deleteFlag: {$ne: true}}, '-deleteFlag'

exports.Class = Article
exports.Instance = new Article()

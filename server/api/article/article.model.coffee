'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require '../../common/BaseModel'

class Article extends BaseModel
  populates:
    index: [
      path: 'author', select: 'name avatar info'
    ]
    show: [
      path: 'author', select: 'name avatar info'
    ]
    create: [
      path: 'author', select: 'name avatar info'
    ]
    update: [
      path: 'author', select: 'name avatar info'
    ]
  schema: new Schema
    title:
      type: String
      required: true
    image:
      type: String
    content:
      type: String
    author:
      type: ObjectId
      ref: 'user'
      required: true
    group:
      type: ObjectId
      ref: 'group'
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
    isPublished:
      type: Boolean
      default: false


exports.Class = Article
exports.Instance = new Article()

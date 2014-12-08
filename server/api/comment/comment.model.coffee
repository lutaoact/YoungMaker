'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require '../../common/BaseModel'

class Comment extends BaseModel
  schema: new Schema
    content:
      type: String
      required: true
    author:
      type: ObjectId
      ref: 'user'
      required: true
    type:
      type: Number # 1.Article 2.Course
      required: true
    belongTo: # article或者course的id
      type: ObjectId
      required: true
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

  getByTypeAndBelongTo: (type, belongTo) ->
    return @findQ {type: type, belongTo: belongTo, deleteFlag: {$ne: true}}, '-deleteFlag'

exports.Class = Comment
exports.Instance = new Comment()

'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require '../../common/BaseModel'

class Comment extends BaseModel
  populates:
    index: [
      path: 'postBy', select: 'name avatar info'
    ]
    show: [
      path: 'postBy', select: 'name avatar info'
    ]
    create: [
      path: 'postBy', select: 'name avatar info'
    ]
    update: [
      path: 'postBy', select: 'name avatar info'
    ]
  schema: new Schema
    content:
      type: String
      required: true
    postBy:
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


  removeByBelongTo: (belongTo) ->
    return @updateQ {belongTo: belongTo}, {deleteFlag: true}, {multi: true}

exports.Class = Comment
exports.Instance = new Comment()

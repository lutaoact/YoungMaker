'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require '../../common/BaseModel'

class Group extends BaseModel
  populates:
    index: [
      path: 'creator', select: 'name avatar'
    ]
    create: [
      path: 'creator', select: 'name avatar'
    ]
    update: [
      path: 'creator', select: 'name avatar'
    ]
    show: [
      path: 'creator', select: 'name avatar'
    ]
  schema: new Schema
    title:
      type: String
      required: true
      unique : true
    description:
      type: String
    avatar:
      type: String
    creator:
      type: ObjectId
      ref: 'user'
      required: true
    members:[
      type: ObjectId
      ref: 'user'
    ]
    deleteFlag:
      type: Boolean
      default: false
    postsCount:
      type: Number
      required: true
      default: 0

exports.Class = Group
exports.Instance = new Group()

'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require '../../common/BaseModel'

class Group extends BaseModel
  populates:
    index: [
      path: 'creator', select: 'name logo info'
    ]
    show: [
      path: 'creator', select: 'name logo info'
    ]
    create: [
      path: 'creator', select: 'name logo info'
    ]
    update: [
      path: 'creator', select: 'name logo info'
    ]
  schema: new Schema
    name:
      type: String
      required: true
      unique : true
    info:
      type: String
    logo:
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
    featured:
      type: Date

exports.Class = Group
exports.Instance = new Group()

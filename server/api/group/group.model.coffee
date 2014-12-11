'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require '../../common/BaseModel'

class Group extends BaseModel
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

exports.Class = Group
exports.Instance = new Group()

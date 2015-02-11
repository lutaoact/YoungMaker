"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel')

class Activity extends BaseModel
  populates:
    index: [
      path: 'userId', select: 'name avatar'
    ,
      path: 'article', select: 'title image'
    ,
      path: 'course', select: 'title image'
    ,
      path: 'group', select: 'name logo'
    ,
      path: 'toUser', select: 'name avatar'
    ]
  schema: new Schema
    userId:
      type: ObjectId
      ref: 'user'
      required: true

    #
    # action:
    #
    # like_article
    # like_course
    # create_article
    # create_course
    # create_group
    # create_follow
    # join_group
    #
    action:
      type: String

    # activity data:
    course:
      type: ObjectId
      ref: 'course'
    article:
      type: ObjectId
      ref: 'article'
    group:
      type: ObjectId
      ref: 'group'
    toUser:
      type: ObjectId
      ref: 'user'

exports.Class = Activity
exports.Instance = new Activity()

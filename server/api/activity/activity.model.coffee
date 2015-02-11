"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel')

activityData = ->
  name:
    type: String
  desc:
    type: String
  image:
    type: String
  objectId:
    type: ObjectId

class Activity extends BaseModel
  populates:
    index: [
      path: 'userId', select: 'name avatar'
    ]
  schema: new Schema
    userId:
      type: ObjectId
      ref: 'user'
      required: true
    # action:
    # like_article
    # like_course
    # create_article
    # create_course
    # create_group
    # create_follow
    # join_group
    action:
      type: String
    # activity data:
    course: activityData()
    article: activityData()
    group: activityData()
    comment: activityData()
    toUser: activityData()

exports.Class = Activity
exports.Instance = new Activity()

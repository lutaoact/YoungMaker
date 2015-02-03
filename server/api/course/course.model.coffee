BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Course extends BaseModel
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
    cover: [ Number ]#表示年龄段的区间吧，其实我也不清楚
    image: String
    videos: [
      type: String
    ]
    content: String
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
    steps: [
      title: String
      content: String
      type:
        type: String
    ]
    pubAt:
      type: Date
      index: true
      sparse: true
    deleteFlag:
      type: Boolean
      default: false

exports.Class = Course
exports.Instance = new Course()

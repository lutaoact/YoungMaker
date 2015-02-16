BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Course extends BaseModel
  populates:
    index: [
        path: 'author'
        select: 'name avatar info'
      ,
        path: 'categoryId'
        select: 'name logo'
    ]
    show: [
        path: 'author'
        select: 'name avatar info'
      ,
        path: 'categoryId'
        select: 'name logo'
    ]
    create: [
        path: 'author'
        select: 'name avatar info'
      ,
        path: 'categoryId'
        select: 'name logo'
    ]
    update: [
        path: 'author'
        select: 'name avatar info'
      ,
        path: 'categoryId'
        select: 'name logo'
    ]

  schema: new Schema
    title:
      type: String
      required: true
    cover: [ Number ]#表示年龄段的区间吧，其实我也不清楚
    image: String
    info: String
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
    categoryId:
      type: ObjectId
      ref: 'category'
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
    featured:
      type: Date

exports.Class = Course
exports.Instance = new Course()

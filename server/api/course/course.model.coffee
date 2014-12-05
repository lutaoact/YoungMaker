BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Course extends BaseModel
  schema: new Schema
    title:
      type: String
      required: true
    cover: [ Number ]#表示年龄段的区间吧，其实我也不清楚
    videos: [
      type: String
    ]
    content: String
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

exports.Class = Course
exports.Instance = new Course()

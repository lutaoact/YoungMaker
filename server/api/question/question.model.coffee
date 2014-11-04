BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Question extends BaseModel
  schema: new Schema
    grade   : String
    subject : String
    type: Number
    desc: String
    keyPoints : [
      type: ObjectId
      ref: "key_point"
    ]
    level:
      type: Number
      default: 50
    tags: [ String ]
    solution: String # 填空题的答案
    hints : String   # 提示富文本
    text_guide : String # 文字详解富文本
    video_guide : String # 视频详解URL

exports.Class = Question
exports.Instance = new Question()

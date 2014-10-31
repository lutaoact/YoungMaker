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
    solution: String #填空题的答案

exports.Class = Question
exports.Instance = new Question()

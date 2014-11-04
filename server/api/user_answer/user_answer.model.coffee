BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class UserAnswer extends BaseModel
  schema: new Schema
    userId:
      type: ObjectId
      ref: "user"
    questionId:
      type: ObjectId
      ref: "question"
    answer: String
    correct:
      type: Boolean
      default: false

exports.Class = UserAnswer
exports.Instance = new UserAnswer()

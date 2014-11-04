BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class WrongQuestion extends BaseModel
  schema: new Schema
    userId :
      type : ObjectId
      ref : 'user'
    questionId :
      type : ObjectId
      ref : 'question'
    answerId :
      type : ObjectId
      ref : 'user_answer'

exports.Class = WrongQuestion
exports.Instance = new WrongQuestion()
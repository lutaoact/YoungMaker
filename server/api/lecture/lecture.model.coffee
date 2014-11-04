BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Lecture extends BaseModel
  schema: new Schema
    title:
      type: String
      required: true
    info    : String
    media: String
    questions: [
      type: ObjectId
      ref: "question"
    ]
    free : Boolean

exports.Class = Lecture
exports.Instance = new Lecture()

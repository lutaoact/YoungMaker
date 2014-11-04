BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Topic extends BaseModel
  schema: new Schema
    gradeSubject:
      type: ObjectId
      ref: 'grade_subject'
    name: String

exports.Class = Topic
exports.Instance = new Topic()

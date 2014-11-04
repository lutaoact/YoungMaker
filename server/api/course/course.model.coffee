BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Course extends BaseModel
  schema: new Schema
    title:
      type: String
      required: true
    info    : String
    gradeSubject:
      type: ObjectId
      ref: 'grade_subject'
    topic:
      type: ObjectId
      ref: 'topic'
    lectures: [
      type: ObjectId
      ref: "lecture"
    ]
    price:
      type: Number
      default: 0

exports.Class = Course
exports.Instance = new Course()

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
    grade   : String
    subject : String
    lectures: [
      type: ObjectId
      ref: "lecture"
    ]
    price:
      type: Number
      default: 0

exports.Class = Course
exports.Instance = new Course()

BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# 年级科目套餐，例如高一物理， 高二化学 etc
class GradeSubject extends BaseModel
  schema: new Schema
    grade : String
    subject :String
    price : 
      type : Number
      default : 0

exports.Class = GradeSubject
exports.Instance = new GradeSubject()

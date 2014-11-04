BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# 年级套餐 例如高一，高二 etc
class Grade extends BaseModel
  schema: new Schema
    name : String
    price : 
      type : Number
      default : 0

exports.Class = Grade
exports.Instance = new Grade()

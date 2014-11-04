BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Subscription extends BaseModel
  schema: new Schema
    userId : 
      type : ObjectId
      ref : 'user'
    type : String # type of purchased product, like grade, grade_subject, course etc
    grade : 
      type : ObjectId # objectId of purchased grade
      ref : 'grade'
    grade_subject :
      type : ObjectId # objectId of purchased grade_subject
      ref : 'grade'
    from: Date
    to: Date

exports.Class = Subscription
exports.Instance = new Subscription()

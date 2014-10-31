BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Subscription extends BaseModel
  schema: new Schema
    type: String # type of purchased product, like grade, grade_subject, course etc
    productId : ObjectId # objectId of purchased product
    from: Date
    to: Date

exports.Class = Subscription
exports.Instance = new Subscription()

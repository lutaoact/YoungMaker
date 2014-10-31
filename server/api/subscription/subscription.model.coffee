BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Subscription extends BaseModel
  schema: new Schema
    type: String
    productId : ObjectId
    from: Date
    to: Date

exports.Class = Subscription
exports.Instance = new Subscription()

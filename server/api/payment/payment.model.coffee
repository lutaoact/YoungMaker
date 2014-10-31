BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema

class Payment extends BaseModel
  schema: new Schema
    userId:
      type: Schema.Types.ObjectId
      ref: "user"
    amount: Number

exports.Class = Payment
exports.Instance = new Payment()

BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema

class Payment extends BaseModel
  constructor: () ->
    @schema = new Schema
      userId: String
      amount: Number

    super

module.exports = Payment

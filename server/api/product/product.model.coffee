BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Product extends BaseModel
  schema: new Schema
    name:
      type: String
      required: true
    provider:
      type: ObjectId
      ref: 'user'
    content: String
    videos: [
      type: String
    ]
    medias: [
      type: String
    ]
    price:
      type: Number
      required: true
    tags: [
      type: String
    ]
    age: [ Number ]#表示年龄段的区间吧，其实我也不清楚

exports.Class = Product
exports.Instance = new Product()

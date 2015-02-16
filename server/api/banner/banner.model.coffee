BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Banner extends BaseModel
  populates: {
  }

  schema: new Schema
    text: String
    image: String
    link: String

exports.Class = Banner
exports.Instance = new Banner()

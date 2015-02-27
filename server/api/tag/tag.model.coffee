BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class Tag extends BaseModel
  populates: {
  }

  schema: new Schema
    text:
      type: String
      required: true
    belongTo: String

  constructor: () ->
    @schema.index {belongTo: 1, text: 1}, {unique: true}
    super

exports.Class = Tag
exports.Instance = new Tag()

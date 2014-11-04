BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class MyCollection extends BaseModel
  schema: new Schema
    userId :
      type : ObjectId
      ref : 'user'
    questionId :
      type : ObjectId
      ref : 'question'

exports.Class = MyCollection
exports.Instance = new MyCollection()
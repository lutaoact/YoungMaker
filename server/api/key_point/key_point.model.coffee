"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.KeyPoint = BaseModel.subclass
  classname: 'KeyPoint'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      categoryId:
        type: Schema.Types.ObjectId
        ref: "category"

    @schema.index
      name : 1
      categoryId: 1
    , 
      unique : true  
      
    $super()

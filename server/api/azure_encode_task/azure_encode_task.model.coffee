"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.AzureEncodeTask = BaseModel.subclass
  classname: 'AzureEncodeTask'
  initialize: ($super) ->
    @schema = new Schema
      inputAssetId:
        type: String
        unique: true
      outputAssetId:
        type: String
      jobId:
        type: String
      taskId:
        type: String

    $super()


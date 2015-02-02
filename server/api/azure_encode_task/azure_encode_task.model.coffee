"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = require '../../common/BaseModel'

class AzureEncodeTask extends BaseModel
  schema: new Schema
    inputAssetId:
      type: String
      unique: true
    outputAssetId:
      type: String
    jobId:
      type: String
    taskId:
      type: String

exports.Class = AzureEncodeTask
exports.Instance = new AzureEncodeTask()

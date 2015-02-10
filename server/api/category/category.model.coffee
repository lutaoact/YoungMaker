"use strict"

mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

BaseModel = (require '../../common/BaseModel')

class Category extends BaseModel
  schema: new Schema
    name:
      type: String
      unique: true
      required: true
    logo:
      type: String


exports.Category = Category
exports.Class = Category
exports.Instance = new Category()

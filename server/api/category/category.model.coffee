"use strict"

mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

class Category extends BaseModel
  classname: 'Category'
  schema: new Schema
    name:
      type: String
      required: true
    orgId:
      type : ObjectId
      required: true
      ref : 'organization'
    deleteFlag:
      type: Boolean
      default: false

    @schema
    .path 'name'
    .validate (name, respond) ->
      self = this
      this.constructor.findOne
        name : name
        orgId: self.orgId
        deleteFlag: $ne: true
      , (err, data) ->
        throw err if err
        notTaken = !data or data.id == self.id
        respond notTaken
    , '该专业名称已被占用，请选择其他名称'


exports.Category = Category

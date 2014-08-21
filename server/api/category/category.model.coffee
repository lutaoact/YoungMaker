
"use strict"

mongoose = require("mongoose")
createdModifiedPlugin = require("mongoose-createdmodified").createdModifiedPlugin
Schema = mongoose.Schema

CategorySchema = new Schema(
  name:
    type: String
    required: true
    unique: true
# sub_category: [{type: Schema.ObjectId, ref: 'Category'}]
)
CategorySchema.plugin createdModifiedPlugin, index: true

module.exports = mongoose.model("Category", CategorySchema)


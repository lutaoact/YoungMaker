"use strict"

mongoose = require("mongoose")
createdModifiedPlugin = require("mongoose-createdmodified").createdModifiedPlugin
Schema = mongoose.Schema

OrganizationSchema = new Schema(
  name:
    type: String
    required: true

  logo: String
  subDomain: String
  background: String # url
  type: String
)
OrganizationSchema.plugin createdModifiedPlugin,
  index: true

module.exports = mongoose.model("Organization", OrganizationSchema)

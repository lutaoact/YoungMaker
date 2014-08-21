(function() {
  "use strict";
  var OrganizationSchema, Schema, createdModifiedPlugin, mongoose;

  mongoose = require("mongoose");

  createdModifiedPlugin = require("mongoose-createdmodified").createdModifiedPlugin;

  Schema = mongoose.Schema;

  OrganizationSchema = new Schema({
    name: {
      type: String,
      required: true
    },
    logo: String,
    subDomain: String,
    background: String,
    type: String
  });

  OrganizationSchema.plugin(createdModifiedPlugin, {
    index: true
  });

  module.exports = mongoose.model("Organization", OrganizationSchema);

}).call(this);

//# sourceMappingURL=organization.model.js.map

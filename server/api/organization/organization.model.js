(function() {
  'use strict';
  var Schema, OrganizationSchema, mongoose, createdModifiedPlugin;

  mongoose = require('mongoose');
  createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin;

  Schema = mongoose.Schema;

  OrganizationSchema = new Schema({
    name: {type: String, required: true},
    logo: String,
    subDomain: String,
    background: String, //url
    type: String
  });

  OrganizationSchema.plugin(createdModifiedPlugin, {index: true});
  module.exports = mongoose.model('Organization', OrganizationSchema);

}).call(this);

//# sourceMappingURL=thing.model.js.map

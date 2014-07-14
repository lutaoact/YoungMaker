(function() {
  'use strict';
  var Schema, ThingSchema, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  ThingSchema = new Schema({
    name: String,
    info: String,
    active: Boolean
  });

  module.exports = mongoose.model('Thing', ThingSchema);

}).call(this);

//# sourceMappingURL=thing.model.js.map

(function() {
  'use strict';
  var Schema, CategorySchema, mongoose, createdModifiedPlugin;

  mongoose = require('mongoose');
  createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin;

  Schema = mongoose.Schema;

  CategorySchema = new Schema({
    name: {type: String, required: true, unique: true},
    // sub_category: [{type: Schema.ObjectId, ref: 'Category'}]
  });

  CategorySchema.plugin(createdModifiedPlugin, {index: true});
  module.exports = mongoose.model('Category', CategorySchema);

}).call(this);

//# sourceMappingURL=thing.model.js.map

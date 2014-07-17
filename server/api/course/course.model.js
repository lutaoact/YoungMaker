(function() {
  'use strict';
  var Schema, CourseSchema, mongoose, createdModifiedPlugin;

  mongoose = require('mongoose');
  createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin;

  Schema = mongoose.Schema;

  CourseSchema = new Schema({
    name: {type: String, required: true},
    category: {type: Schema.Types.ObjectId, ref: 'Category'},
    thumbnail: String,
    info: String,
    owners: [{type: Schema.Types.ObjectId, ref: 'User'}],
    classes: [{type: Schema.Types.ObjectId, ref: 'Classe'}]
  });

  CourseSchema.plugin(createdModifiedPlugin, {index: true});
  module.exports = mongoose.model('Course', CourseSchema);

}).call(this);

//# sourceMappingURL=thing.model.js.map

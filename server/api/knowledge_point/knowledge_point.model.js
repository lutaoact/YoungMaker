(function() {
  'use strict';
  var Schema, KnowledgePointSchema, mongoose, createdModifiedPlugin;

  mongoose = require('mongoose');
  createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin;

  Schema = mongoose.Schema;

  KnowledgePointSchema = new Schema({
    name: {type: String, required: true, unique: true},
    categoryId: {type: Schema.Types.ObjectId, ref: 'Lecture'},
    importance: String
  });

  KnowledgePointSchema.plugin(createdModifiedPlugin, {index: true});
  module.exports = mongoose.model('KnowledgePoint', KnowledgePointSchema);

}).call(this);

//# sourceMappingURL=thing.model.js.map

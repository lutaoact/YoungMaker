(function() {
  'use strict';
  var Schema, ClasseSchema, mongoose, createdModifiedPlugin;

  mongoose = require('mongoose');
  createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin;

  Schema = mongoose.Schema;

  ClasseSchema = new Schema({
    name: {type: String, required: true},
    organization: {type: Schema.Types.ObjectId, ref: 'Organization'},
    students: [{type: Schema.Types.ObjectId, ref: 'User'}],
    year_grade: String
  });

  ClasseSchema.plugin(createdModifiedPlugin, {index: true});
  module.exports = mongoose.model('Classe', ClasseSchema);

}).call(this);

//# sourceMappingURL=thing.model.js.map

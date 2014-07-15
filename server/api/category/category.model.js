(function() {
  'use strict';
  var Schema, CategorySchema, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  CategorySchema = new Schema({
    name: {type: String, required: true, unique: true},
    // sub_category: [{type: Schema.ObjectId, ref: 'Category'}]
  });

  module.exports = mongoose.model('Category', CategorySchema);

}).call(this);

//# sourceMappingURL=thing.model.js.map

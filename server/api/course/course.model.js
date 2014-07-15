(function() {
  'use strict';
  var Schema, CourseSchema, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  CourseSchema = new Schema({
    name: {type: String, required: true},
    category: {type: Schema.ObjectId, ref: 'Category'},
    thumbnail: String,
    info: String,
    owners: [{type: Schema.ObjectId, ref: 'User'}],
    classes: [{type: Schema.ObjectId, ref: 'Class'}]
  });

  module.exports = mongoose.model('Course', CourseSchema);

}).call(this);

//# sourceMappingURL=thing.model.js.map

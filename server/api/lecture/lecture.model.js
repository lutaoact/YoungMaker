(function() {
  'use strict';
  var Schema, LecutreSchema, mongoose, createdModifiedPlugin;

  mongoose = require('mongoose');
  createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin;

  Schema = mongoose.Schema;

  LecutreSchema = new Schema({
    name: {type: String, required: true},
    courseId: {type: Schema.Types.ObjectId, required: true, ref: 'Course'},
    thumbnail: String,
    info: String,
    slides: [{
      thumb: String,
      raw: String
    }],
    knowledgePoints: [{type: Schema.Types.ObjectId, ref: 'KnowledgePoint'}]
    // TODO: define Quesiton DB
    //questions: {type: Schema.Types.ObjectId, ref: 'Question'}
  });

  LecutreSchema.plugin(createdModifiedPlugin, {index: true});
  module.exports = mongoose.model('Lecture', LecutreSchema);

}).call(this);

//# sourceMappingURL=thing.model.js.map

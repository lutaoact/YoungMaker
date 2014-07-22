(function() {
  'use strict';
  var Schema, ClassProgressSchema, mongoose, createdModifiedPlugin;

  mongoose = require('mongoose');
  createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin;

  Schema = mongoose.Schema;

  ClassProgressSchema = new Schema({
    userId: {type: Schema.Types.ObjectId, ref: 'User'},
    courseId: {type: Schema.Types.ObjectId, ref: 'Course'},
    classId: {type: Schema.Types.ObjectId, ref: 'Class'},
    // TODO: does lecturesStatus need _id?
    lecturesStatus: [{
      lectureId: {type: Schema.Types.ObjectId, ref: 'Lecture'},
      //name: String,
      isFinished: Boolean
    }],
    timeTable: [{
      name: String,
      time: Date
    }]
  });

  ClassProgressSchema.plugin(createdModifiedPlugin, {index: true});
  module.exports = mongoose.model('ClassProgress', ClassProgressSchema);

}).call(this);

//# sourceMappingURL=thing.model.js.map

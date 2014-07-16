(function() {
  'use strict';
  var Schema, SolutionSchema, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  SolutionSchema = new Schema({
    question_id: String,
    content: String, // url
    key_points: String,
    course: { type: Schema.Types.ObjectId, ref: 'Course' }
    // sub_category: [{type: Schema.ObjectId, ref: 'Solution'}]
  });

  module.exports = mongoose.model('Solution', SolutionSchema);

}).call(this);

//# sourceMappingURL=thing.model.js.map

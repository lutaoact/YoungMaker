(function() {
  "use strict";
  var LecutreSchema, Schema, createdModifiedPlugin, mongoose;

  mongoose = require("mongoose");

  createdModifiedPlugin = require("mongoose-createdmodified").createdModifiedPlugin;

  Schema = mongoose.Schema;

  LecutreSchema = new Schema({
    name: {
      type: String,
      required: true
    },
    courseId: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "Course"
    },
    thumbnail: String,
    info: String,
    slides: [
      {
        thumb: String,
        raw: String
      }
    ],
    knowledgePoints: [
      {
        type: Schema.Types.ObjectId,
        ref: "KnowledgePoint"
      }
    ]
  });

  LecutreSchema.plugin(createdModifiedPlugin, {
    index: true
  });

  module.exports = mongoose.model("Lecture", LecutreSchema);

}).call(this);

//# sourceMappingURL=lecture.model.js.map

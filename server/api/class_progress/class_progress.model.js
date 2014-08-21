(function() {
  "use strict";
  var ClassProgressSchema, Schema, createdModifiedPlugin, mongoose;

  mongoose = require("mongoose");

  createdModifiedPlugin = require("mongoose-createdmodified").createdModifiedPlugin;

  Schema = mongoose.Schema;

  ClassProgressSchema = new Schema({
    userId: {
      type: Schema.Types.ObjectId,
      ref: "User"
    },
    courseId: {
      type: Schema.Types.ObjectId,
      ref: "Course"
    },
    classId: {
      type: Schema.Types.ObjectId,
      ref: "Class"
    },
    lecturesStatus: [
      {
        lectureId: {
          type: Schema.Types.ObjectId,
          ref: "Lecture"
        },
        isFinished: Boolean
      }
    ],
    timeTable: [
      {
        name: String,
        time: Date
      }
    ]
  });

  ClassProgressSchema.plugin(createdModifiedPlugin, {
    index: true
  });

  module.exports = mongoose.model("ClassProgress", ClassProgressSchema);

}).call(this);

//# sourceMappingURL=class_progress.model.js.map

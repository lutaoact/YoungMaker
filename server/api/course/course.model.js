(function() {
  "use strict";
  var CourseSchema, Schema, createdModifiedPlugin, mongoose;

  mongoose = require("mongoose");

  createdModifiedPlugin = require("mongoose-createdmodified").createdModifiedPlugin;

  Schema = mongoose.Schema;

  CourseSchema = new Schema({
    name: {
      type: String,
      required: true
    },
    categoryId: {
      type: Schema.Types.ObjectId,
      ref: "Category"
    },
    thumbnail: String,
    info: String,
    lectureAssembly: [
      {
        type: Schema.Types.ObjectId,
        ref: "Lecture"
      }
    ],
    owners: [
      {
        type: Schema.Types.ObjectId,
        ref: "User"
      }
    ],
    classes: [
      {
        type: Schema.Types.ObjectId,
        ref: "Classe"
      }
    ]
  });

  CourseSchema.plugin(createdModifiedPlugin, {
    index: true
  });

  module.exports = mongoose.model("Course", CourseSchema);

}).call(this);

//# sourceMappingURL=course.model.js.map

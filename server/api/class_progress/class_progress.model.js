(function() {
  "use strict";
  var BaseModel, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.ClassProgress = BaseModel.subclass({
    classname: 'ClassProgress',
    initialize: function($super) {
      this.schema = new Schema({
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
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=class_progress.model.js.map

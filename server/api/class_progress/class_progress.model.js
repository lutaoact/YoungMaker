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
          ref: "user"
        },
        courseId: {
          type: Schema.Types.ObjectId,
          ref: "course"
        },
        classId: {
          type: Schema.Types.ObjectId,
          ref: "class"
        },
        lecturesStatus: [
          {
            lectureId: {
              type: Schema.Types.ObjectId,
              ref: "lecture"
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

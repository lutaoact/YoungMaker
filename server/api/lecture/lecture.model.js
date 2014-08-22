(function() {
  "use strict";
  var BaseModel, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.Lecture = BaseModel.subclass({
    classname: 'Lecture',
    initialize: function($super) {
      this.schema = new Schema({
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
            thumb: String
          }
        ],
        knowledgePoints: [
          {
            type: Schema.Types.ObjectId,
            ref: "KnowledgePoint"
          }
        ]
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=lecture.model.js.map

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
        thumbnail: String,
        info: String,
        slides: [
          {
            thumb: String
          }
        ],
        media: String,
        keyPoints: [
          {
            type: Schema.Types.ObjectId,
            ref: "key_point"
          }
        ],
        quizzes: [
          {
            type: Schema.Types.ObjectId,
            ref: "question"
          }
        ],
        homeworks: [
          {
            type: Schema.Types.ObjectId,
            ref: "question"
          }
        ]
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=lecture.model.js.map

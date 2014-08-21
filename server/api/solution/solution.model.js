(function() {
  "use strict";
  var BaseModel, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.Solution = BaseModel.subclass({
    classname: 'Solution',
    initialize: function($super) {
      this.schema = new Schema({
        question_id: String,
        content: String,
        keyPoints: String,
        course: {
          type: Schema.Types.ObjectId,
          ref: 'course'
        }
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=solution.model.js.map

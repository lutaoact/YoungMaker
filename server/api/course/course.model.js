(function() {
  "use strict";
  var BaseModel, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.Course = BaseModel.subclass({
    classname: 'Course',
    initialize: function($super) {
      this.schema = new Schema({
        name: {
          type: String,
          required: true
        },
        categoryId: {
          type: Schema.Types.ObjectId,
          ref: "category"
        },
        thumbnail: String,
        info: String,
        lectureAssembly: [
          {
            type: Schema.Types.ObjectId,
            ref: "lecture"
          }
        ],
        owners: [
          {
            type: Schema.Types.ObjectId,
            ref: "user"
          }
        ],
        classes: [
          {
            type: Schema.Types.ObjectId,
            ref: "classe"
          }
        ]
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=course.model.js.map

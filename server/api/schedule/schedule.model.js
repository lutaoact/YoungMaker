(function() {
  "use strict";
  var BaseModel, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.Schedule = BaseModel.subclass({
    classname: 'Schedule',
    initialize: function($super) {
      this.schema = new Schema({
        classeId: {
          type: Schema.Types.ObjectId,
          ref: 'classe'
        },
        courseId: {
          type: Schema.Types.ObjectId,
          ref: "course"
        },
        data: Schema.Types.Mixed
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=schedule.model.js.map

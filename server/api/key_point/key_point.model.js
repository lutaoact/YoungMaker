(function() {
  "use strict";
  var BaseModel, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.KeyPoint = BaseModel.subclass({
    classname: 'KeyPoint',
    initialize: function($super) {
      this.schema = new Schema({
        name: {
          type: String,
          required: true,
          unique: true
        },
        categoryId: {
          type: Schema.Types.ObjectId,
          ref: "category"
        }
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=key_point.model.js.map

(function() {
  "use strict";
  var BaseModel, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.Category = BaseModel.subclass({
    classname: 'Category',
    initialize: function($super) {
      this.schema = new Schema({
        name: {
          type: String,
          required: true,
          unique: true
        }
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=category.model.js.map

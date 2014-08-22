(function() {
  "use strict";
  var BaseModel, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.Organization = BaseModel.subclass({
    classname: 'Organization',
    initialize: function($super) {
      this.schema = new Schema({
        uniqueName: {
          type: String,
          required: true,
          unique: true
        },
        name: {
          type: String,
          required: true
        },
        logo: String,
        description: String,
        type: {
          type: String,
          required: true,
          unique: true
        }
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=organization.model.js.map

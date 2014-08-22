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
        uniqueName: String,
        name: {
          type: String,
          required: true
        },
        logo: String,
        description: String,
        type: String
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=organization.model.js.map

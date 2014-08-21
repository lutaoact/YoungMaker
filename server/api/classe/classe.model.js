(function() {
  "use strict";
  var BaseModel, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.Classe = BaseModel.subclass({
    classname: 'Classe',
    initialize: function($super) {
      this.schema = new Schema({
        name: {
          type: String,
          required: true
        },
        orgId: {
          type: Schema.Types.ObjectId,
          ref: "Organization"
        },
        students: [
          {
            type: Schema.Types.ObjectId,
            ref: "User"
          }
        ],
        yearGrade: String
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=classe.model.js.map

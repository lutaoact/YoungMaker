(function() {
  "use strict";
  var BaseModel, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.KnowledgePoint = BaseModel.subclass({
    classname: 'KnowledgePoint',
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

//# sourceMappingURL=knowledge_point.model.js.map

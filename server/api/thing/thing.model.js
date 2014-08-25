(function() {
  'use strict';
  var BaseModel, Schema, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.Thing = BaseModel.subclass({
    classname: 'Thing',
    initialize: function($super) {
      this.schema = new Schema({
        name: String,
        info: String,
        active: Boolean
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=thing.model.js.map

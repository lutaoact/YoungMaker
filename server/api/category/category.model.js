(function() {
  "use strict";
  var CategorySchema, Schema, createdModifiedPlugin, mongoose;

  mongoose = require("mongoose");

  createdModifiedPlugin = require("mongoose-createdmodified").createdModifiedPlugin;

  Schema = mongoose.Schema;

  CategorySchema = new Schema({
    name: {
      type: String,
      required: true,
      unique: true
    }
  });

  CategorySchema.plugin(createdModifiedPlugin, {
    index: true
  });

  module.exports = mongoose.model("Category", CategorySchema);

}).call(this);

//# sourceMappingURL=category.model.js.map

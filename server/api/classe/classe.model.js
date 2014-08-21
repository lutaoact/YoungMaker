(function() {
  "use strict";
  var ClasseSchema, Schema, createdModifiedPlugin, mongoose;

  mongoose = require("mongoose");

  createdModifiedPlugin = require("mongoose-createdmodified").createdModifiedPlugin;

  Schema = mongoose.Schema;

  ClasseSchema = new Schema({
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

  ClasseSchema.plugin(createdModifiedPlugin, {
    index: true
  });

  module.exports = mongoose.model("Classe", ClasseSchema);

}).call(this);

//# sourceMappingURL=classe.model.js.map

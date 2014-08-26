(function() {
  "use strict";
  var auth, controller, express, router;

  express = require("express");

  controller = require("./key_point.controller");

  auth = require("../../auth/auth.service");

  router = express.Router();

  router.get("/", controller.index);

  router.get("/:id", controller.show);

  router.post("/", auth.hasRole("teacher"), controller.create);

  router["delete"]("/:id", auth.hasRole("teacher"), controller.destroy);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map

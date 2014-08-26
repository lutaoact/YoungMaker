(function() {
  "use strict";
  var auth, controller, express, router;

  express = require("express");

  controller = require("./category.controller");

  auth = require("../../auth/auth.service");

  router = express.Router();

  router.get("/", auth.isAuthenticated(), controller.index);

  router.post("/", auth.hasRole("admin"), controller.create);

  router["delete"]("/:id", auth.hasRole("admin"), controller.destroy);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map

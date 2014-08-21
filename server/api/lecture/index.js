(function() {
  "use strict";
  var auth, controller, express, router;

  express = require("express");

  controller = require("./lecture.controller");

  auth = require("../../auth/auth.service");

  router = express.Router();

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map

(function() {
  "use strict";
  var auth, controller, express, router;

  express = require("express");

  controller = require("./discussion.controller");

  auth = require("../../auth/auth.service");

  router = express.Router();

  router.get('/', auth.isAuthenticated(), controller.index);

  router.post('/', auth.isAuthenticated(), controller.create);

  router.get('/:id', auth.isAuthenticated(), controller.show);

  router.put('/', auth.isAuthenticated(), controller.update);

  router.patch('/', auth.isAuthenticated(), controller.update);

  router["delete"]('/:id', auth.isAuthenticated(), controller.destroy);

  router.post('/:id/votes', auth.isAuthenticated(), controller.vote);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map

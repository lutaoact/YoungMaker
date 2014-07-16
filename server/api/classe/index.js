(function() {
  'use strict';
  var controller, express, router, auth;

  express = require('express');

  controller = require('./classe.controller');

  auth = require('../../auth/auth.service');

  router = express.Router();

  router.get('/', auth.isAuthenticated(), controller.index);

  router.get('/:id', controller.show);

  router.post('/', controller.create);

  router.put('/:id', controller.update);

  router.patch('/:id', controller.update);

  router["delete"]('/:id', controller.destroy);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map

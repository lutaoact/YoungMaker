(function() {
  'use strict';
  var controller, express, router, auth;

  express = require('express');

  controller = require('./course.controller');

  auth = require('../../auth/auth.service');

  router = express.Router();

  router.get('/', auth.hasRole('teacher'), controller.index);

  router.get('/:id', auth.isAuthenticated(), controller.show);

  router.get('/:id/lectures', auth.isAuthenticated(), controller.showLectures);

  router.post('/', auth.hasRole('teacher'), controller.create);

  router.put('/:id', auth.hasRole('teacher'), controller.update);

  router.patch('/:id', auth.hasRole('teacher'), controller.update);

  // router["delete"]('/:id', controller.destroy);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map

(function() {
  'use strict';
  var auth, controller, express, router;

  express = require('express');

  controller = require('./user.controller');

  auth = require('../../auth/auth.service');

  router = express.Router();

  router.get('/', auth.hasRole('admin'), controller.index);

  router["delete"]('/:id', auth.hasRole('admin'), controller.destroy);

  router.get('/me', auth.isAuthenticated(), controller.me);

  router.post('/forget', controller.forget);

  router.post('/reset/:email/:token', controller.reset);

  router.put('/:id/password', auth.isAuthenticated(), controller.changePassword);

  router.put('/:id', auth.isAuthenticated(), controller.update);

  router.patch('/:id', auth.isAuthenticated(), controller.update);

  router.get('/:id', auth.isAuthenticated(), controller.show);

  router.post('/', controller.create);

  router.post('/bulk', controller.bulkImport);

  router.get('/emails/:email', auth.isAuthenticated(), controller.showByEmail);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map

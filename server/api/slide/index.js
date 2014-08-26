(function() {
  'use strict';
  var auth, controller, express, router;

  express = require('express');

  controller = require('./slide.controller');

  auth = require('../../auth/auth.service');

  router = express.Router();

  router.post('/:key', auth.hasRole('teacher'), controller.process);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map

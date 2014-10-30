'use strict';

var express = require('express');
var passport = require('passport');
var config = require('../config/environment');
var User = _u.getModel("user");

// Passport Configuration
require('./local/passport').setup(User, config);

var router = express.Router();

router.use('/local', require('./local'));

module.exports = router;

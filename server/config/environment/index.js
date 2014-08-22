(function() {
  'use strict';
  var all, path, requiredProcessEnv, _;

  path = require('path');

  _ = require('lodash');

  requiredProcessEnv = function(name) {
    if (!process.env[name]) {
      throw new Error('You must set the ' + name + ' environment variable');
    }
    return process.env[name];
  };

  all = {
    env: process.env.NODE_ENV,
    root: path.normalize(__dirname + '/../../..'),
    port: process.env.PORT || 9000,
    seedDB: false,
    secrets: {
      session: process.env.EXPRESS_SECRET || 'budweiser-secret'
    },
    userRoles: ['student', 'admin', 'teacher'],
    mongo: {
      options: {
        db: {
          safe: true
        }
      }
    },
    tmpDir: '/tmp'
  };

  module.exports = _.merge(all, require('./' + process.env.NODE_ENV + '.js') || {});

}).call(this);

//# sourceMappingURL=index.js.map

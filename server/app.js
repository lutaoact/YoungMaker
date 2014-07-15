
/*
Main application file
 */

(function() {
  'use strict';
  var app, config, exports, express, mongoose, server, socketio;

  process.env.NODE_ENV = process.env.NODE_ENV || 'development';

  express = require('express');

  mongoose = require('mongoose');

  config = require('./config/environment');

  mongoose.connect(config.mongo.uri, config.mongo.options);

  if (config.seedDB) {
    require('./config/seed');
  }

  app = express();

  server = require('http').createServer(app);

  socketio = require('socket.io').listen(server);

  require('./config/socketio')(socketio);

  require('./config/express')(app);

  require('./routes')(app);

  server.listen(config.port, config.ip, function() {
    return console.log('Express server listening on %d, in %s mode', config.port, app.get('env'));
  });

  exports = module.exports = app;

}).call(this);

//# sourceMappingURL=app.js.map

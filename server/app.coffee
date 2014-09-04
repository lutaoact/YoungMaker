###
Main application file
###

'use strict'
require './common/init' #init global object

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || 'development'

express = require('express')
#mongoose = require('mongoose')
config = require('./config/environment')

# Connect to database
#mongoose.connect(config.mongo.uri, config.mongo.options)

# Populate DB with sample data
if(config.seedDB)
  require('./config/seed_data')

# Setup server
app = express()
server = require('http').createServer(app)

sockjs = require 'sockjs'
sockjs_server = sockjs.createServer();
sockjs_server.installHandlers server, {prefix : '/sockjs'}
require('./config/sockjs')(sockjs_server)

#socketio = require('socket.io').listen(server)
#require('./config/socketio')(socketio)
require('./config/express')(app)
require('./routes')(app)

# Start server
server.listen(config.port, config.ip,  () ->
  console.log('Express server listening on %d, in %s mode', config.port, app.get('env'))
)

# Expose app
exports = module.exports = app

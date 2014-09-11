###
Main application file
###

'use strict'
require './common/init' #init global object

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || 'development'

express = require('express')
config = require('./config/environment')

# Populate DB with sample data
if(config.seedDB)
  require('./config/seed_data')

# Setup server
app = express()
server = require('http').createServer(app)

# set up sockjs server
sockjs = require 'sockjs'
sockjs_server = sockjs.createServer()
sockjs_server.installHandlers server, {prefix : '/sockjs'}
require('./config/set_sockjs').init(sockjs_server)

# Start server
require('./config/express')(app)
require('./routes')(app)
server.listen(config.port, config.ip,  () ->
  console.log('Express server listening on %d, in %s mode', config.port, app.get('env'))
)

# Expose app
exports = module.exports = app

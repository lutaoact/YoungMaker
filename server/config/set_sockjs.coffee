'use strict'

global.socketMap = {}
routes = require('../api/socket/').routes

SocketUtils = _u.getUtils 'socket'

exports.init = (sockjs_server) ->
  sockjs_server.on 'connection', (conn) ->
    conn.on 'data', (data) ->
      msg = JSON.parse data
      logger.info msg
      SocketUtils.verify msg.payload.token
      .then (user) ->
        logger.info global.socketMap
        if global.socketMap[user._id]?
          global.socketMap[user._id].beatAt = _u.time()
        else
          global.socketMap[user._id] = beatAt: _u.time(), ws: conn

#        global.socketMap[user._id].ws.write JSON.stringify result:'ok'

#        routes[msg.type] user, msg.payload #if we need more, uncomment this line
      , (err) ->
        logger.error err

    conn.on 'close', () ->
      logger.info 'some socket is closed'
      for userId, current of global.socketMap
        if current.ws is conn
          conn = null
          delete global.socketMap[userId]
          logger.info "userId: #{userId}, websocket closed"


setInterval () ->
  #TODO: check and close sockets that not sent heart beat for some long time.
  console.log 'no alive socket'
, 10 * 60 * 1000

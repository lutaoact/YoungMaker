'user strict'

onData = (msg) ->
  console.log msg

onClose = () ->
  console.log 'Sockjs connection closed'


module.exports = (sock_srv) ->
  sock_srv.on 'connection', (conn) ->

    console.log 'Sockjs connection is...'
    console.dir conn

    conn.on 'data', (msg) ->
      console.log msg
    conn.on 'close', onClose

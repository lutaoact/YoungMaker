'use strict'

angular.module('maui.components')

.service 'socket', (
  ipCookie
  $timeout
  $interval
) ->

  socket = null
  heartbeat = null
  handler = {}

  setup: ->
    if socket? then return
    socket = new SockJS '/sockjs'

    beatTime = 5 * 60 * 1000 #server 10 分钟检查一次

    doBeat = (type = 'beat') ->
      socket.send JSON.stringify
        type: type
        token: ipCookie('token') if ipCookie('token')

    socket.onopen =  ->
      doBeat('login')
      heartbeat = $interval doBeat, beatTime

    socket.onmessage = (event) -> $timeout ->
      result = angular.fromJson(event.data)
      type = result.type
      payload = result.payload
      handler[type]?(payload)

    socket.onclose = ( (event) ->
      @close()
    ).bind @

  setHandler: (type, callback) ->
    handler[type] = callback

  removeHandler: (type) ->
    delete handler[type]

  hasHandler: (type) -> handler.hasOwnProperty(type)

  hasOpen: -> socket?

  resetHandler: ->
    handler = {}

  send: (data) ->
    data.token = ipCookie('token') if ipCookie('token')
    socket?.send(data)

  close: ->
    if !socket? then return
    $interval.cancel(heartbeat)
    heartbeat = null
    @resetHandler()
    delete socket.onopen
    delete socket.onmessage
    socket?.close()
    socket = null



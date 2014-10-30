'use strict'

angular.module('mauiApp').service 'socket', (
  $timeout
  $interval
  $cookieStore
) ->

  socket = null
  heartbeat = null
  handler = {}

  setup: ->
    if socket? then return
    socket = new SockJS '/sockjs'

    beatTime = 5 * 60 * 1000 #server 10 分钟检查一次

    doBeat = (type = 'beat') ->
#      console.debug 'socket.' + type
      socket.send JSON.stringify
        type: type
        token: $cookieStore.get('token') if $cookieStore.get('token')

    socket.onopen =  ->
      doBeat('login')
      heartbeat = $interval doBeat, beatTime

    socket.onmessage = (event) -> $timeout ->
      console.debug 'Receive socket message', event
      result = angular.fromJson(event.data)
      type = result.type
      payload = result.payload
      handler[type]?(payload)

    socket.onclose = ( (event) ->
      @close()
      console.debug 'socket connection close', event
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
    data.token = $cookieStore.get('token') if $cookieStore.get('token')
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



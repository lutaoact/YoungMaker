'use strict'

angular.module('budweiserApp').service 'socket', (
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

    doBeat = ->
      socket.send JSON.stringify
        type: 'beat'
        token: $cookieStore.get('token') if $cookieStore.get('token')

    socket.onopen =  ->
      doBeat()
      heartbeat = $interval doBeat, beatTime

    socket.onmessage = (event) -> $timeout ->
      result = angular.fromJson(event.data)
      console.debug 'Receive socket message', result
      type = result.type
      payload = result.payload
      handler[type]?(payload)

    socket.onclose = ( (event) ->
      @close()
      console.debug event
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



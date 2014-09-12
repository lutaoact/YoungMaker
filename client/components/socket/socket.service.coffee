'use strict'

angular.module('budweiserApp').service 'socket', ($timeout, $cookieStore, $interval, $rootScope) ->

  socket = undefined
  heartbeat = undefined
  # TODO: allow multi listen
  handler = {}

  setup: (user) ->
    if socket? then return
    socket = new SockJS '/sockjs'
    console.debug 'Setup socket connect... ', socket

    socket.onopen =  ->
      heartbeat = $interval ->
        beat =
          type: 'beat'
          token: $cookieStore.get('token') if $cookieStore.get('token')
        socket.send JSON.stringify beat
      , 3 * 1000

    socket.onmessage = (event) -> $timeout ->
      result = angular.fromJson(event.data)
      console.debug 'Receive socket message... ', result
      type = result.type
      payload = result.payload
      handler[type]?(payload)

    socket.onclose = ( (event) ->
      @close()
      console.log event
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
    $interval.cancel(heartbeat);
    heartbeat = undefined
    socket?.close()
    delete socket.onopen
    delete socket.onmessage
    socket = undefined



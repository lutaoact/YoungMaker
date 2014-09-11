'use strict'

angular.module('budweiserApp').service 'socket', ($timeout) ->

  socket = undefined
  handler = {}

  # todo: heartbeat when alive.
  setup: (user) ->
    if socket? then return
    socket = new SockJS '/sockjs'
    console.debug 'Setup socket connect... ', socket

    socket.onopen = ->
      msg =
        type : 'login'
        payload:
          userId : user._id
          role : user.role
      socket.send JSON.stringify msg

    socket.onmessage = (event) -> $timeout ->
      result = angular.fromJson(event.data)
      console.debug 'Receive socket message... ', result
      type = result.type
      payload = result.payload
      handler[type]?(payload)

  setHandler: (type, callback) ->
    handler[type] = callback

  removeHandler: (type) ->
    delete handler[type]

  hasHandler: (type) -> handler.hasOwnProperty(type)

  hasOpen: -> socket?

  resetHandler: ->
    handler = {}

  send: (data) ->
    socket?.send(data)

  close: ->
    socket?.close()
    delete socket.onopen
    delete socket.onmessage
    socket = undefined



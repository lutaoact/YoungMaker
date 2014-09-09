'use strict'

angular.module('budweiserApp').service 'socket', ($timeout) ->

  socket = undefined

  asyncCallback = (callback) ->
    if angular.isFunction(callback) then ->
      args = arguments
      $timeout -> callback.apply(socket, args)
    else angular.noop

  setup: (user) ->
    if socket? then throw 'socket already setup'
    socket = new SockJS '/sockjs'
#    console.debug 'Setup socket connect... ', socket
    socket.onopen = ->
      msg =
        type : 'login'
        payload:
          userId : user._id
          role : user.role
      socket.send JSON.stringify msg
  setHandler: (event, callback) ->
    socket?['on' + event] = asyncCallback(callback)
    this
  removeHandler: (event) ->
    delete socket?['on' + event]
    this
  send: ->
    socket?.send?(socket, arguments)
  close: ->
    socket?.close?(socket, arguments)
    socket = undefined



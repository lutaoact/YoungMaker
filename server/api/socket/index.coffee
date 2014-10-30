'use strict'

#TODO: this file is left for future use

exports.login = (user, payload) ->
  console.log 'login'
  console.log payload


exports.beat = (user, payload) ->
  console.log 'beat'
  global.socketMap[user._id]?.ws?.write JSON.stringify result:'ok'


exports.routes =
  login:  exports.login
  beat :  exports.beat

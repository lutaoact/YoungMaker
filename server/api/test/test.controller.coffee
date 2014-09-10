"use strict"

sockjs_srv = require '../../config/sockjs_srv'

exports.socket = (req, res) ->
  sockjs_srv.test 'hello world!'
  res.send 200
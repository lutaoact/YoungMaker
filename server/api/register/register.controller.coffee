"use strict"

User = _u.getModel 'user'

exports.createUser = (req, res, next) ->
  body = req.body

  user =
    email   : body.email
    password: body.password
    name    : body.name

  User.createQ user
  .then (result) ->
    res.send
      email: result.email
      name : result.name
  .catch next
  .done()

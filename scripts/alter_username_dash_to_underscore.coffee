'use strict'
require '../server/common/init'

User = _u.getModel 'user'
User.findQ username: /-/
.then (users) ->
  allPromises = for user in users
    newName = user.username.replace '-', '_'
    user.username = newName
    user.password = newName
    user.saveQ()

  Q.all allPromises
.then (result) ->
#  console.log result
  console.log 'finished...success'
, (err) ->
  console.log err

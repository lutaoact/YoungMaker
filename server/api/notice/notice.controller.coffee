'use strict'

Notice = _u.getModel 'notice'

exports.index = (req, res, next) ->
  userId = req.user.id

  #status: 0 -> unread
  Notice.findQ userId: userId, status: 0
  .then (notices) ->
    res.send notices
  , next

exports.read = (req, res, next) ->
  ids = req.body.ids
  Notice.updateQ
    _id: $in: ids
    userId: req.user._id
  ,
    $set: status: 1#status: 1 -> read
  ,
    multi: true
  .then (result) ->
    res.send 200, result
  , next

'use strict'

Notice = _u.getModel 'notice'

exports.index = (req, res, next) ->
  userId = req.user.id

  #status: 0 -> unread
  Notice.findQ userId: userId, status: 0
  .then (notices) ->
    res.send notices
  , next

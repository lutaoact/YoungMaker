'use strict'

Notice = _u.getModel 'notice'

WrapRequest = new (require '../../utils/WrapRequest')(Notice)

exports.index = (req, res, next) ->
  userId = req.user.id

  conditions = {}
  conditions.userId = userId
  if !req.query.all
    conditions.status = 0
  options =
    limit: req.query.limit
    from: req.query.from
    sort: req.query.sort
  WrapRequest.wrapPageIndex req, res, next, conditions, options

exports.read = (req, res, next) ->
  ids = req.body.ids
  Notice.updateQ
    _id: $in: ids
    userId: req.user._id
  ,
    $set: status: 1 #status: 1 -> read
  ,
    multi: true
  .then (result) ->
    res.send 200, result[1]
  , next

exports.unreadCount = (req, res, next) ->
  userId = req.user.id
  conditions =
    userId: userId
    status: 0
  Notice.countQ conditions
  .then (count)->
    console.log count
    res.send 200, unreadCount: count
  .catch next
  .done()
"use strict"

Activity = _u.getModel 'activity'
Follow = _u.getModel 'follow'
WrapRequest = new (require '../../utils/WrapRequest')(Activity)

exports.index = (req, res, next) ->
  userIds = []
  Q(
    if req.params.userId is req.user?.id
      Follow.getAllFollowings req.user.id
      .then (follows) ->
        userIds = _.pluck follows, 'to'
  ).then () ->
    userIds.push req.params.userId
    conditions = {userId: {$in: userIds}}
    WrapRequest.wrapPageIndex req, res, next, conditions
  .catch next
  .done()

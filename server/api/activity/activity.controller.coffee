"use strict"

Activity = _u.getModel 'activity'
Follow = _u.getModel 'follow'
WrapRequest = new (require '../../utils/WrapRequest')(Activity)

exports.index = (req, res, next) ->
  Follow.getAllFollowings req.user._id
  .then (follows) ->
    followingUserIds = _.pluck follows, 'to'
    followingUserIds.push req.user._id

    conditions = {userId: {$in: followingUserIds}}
    WrapRequest.wrapPageIndex req, res, next, conditions
  .catch next
  .done()

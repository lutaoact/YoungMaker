
Follow = _u.getModel 'follow'
NoticeUtils = _u.getUtils 'notice'
WrapRequest = new (require '../../utils/WrapRequest')(Follow)

exports.index = (req, res, next) ->
  conditions = {}
  conditions.from = req.query.fromUserId if req.query.fromUserId
  conditions.to   = req.query.toUserId if req.query.toUserId

  WrapRequest.wrapPageIndex req, res, next, conditions


#exports.num = (req, res, next) ->
#  Q.all [
#    Follow.countQ {from: req.query.userId}
#    Follow.countQ {to: req.query.userId}
#  ]
#  .spread (numFollowing, numFollower) ->
#    res.send
#      numFollowing: numFollowing
#      numFollower : numFollower
#  .catch next
#  .done()
#


exports.show = (req, res, next) ->
  conditions =
    from: req.user._id
    to  : req.params.toUserId
  WrapRequest.wrapShow req, res, next, conditions


exports.follow = (req, res, next) ->
  data =
    from: req.user._id
    to  : req.body.to

  WrapRequest.wrapCreate req, res, next, data
  NoticeUtils.addNotice data.to, data.from, Const.NoticeType.FollowUser


exports.unfollow = (req, res, next) ->
  conditions =
    from: req.user._id
    to  : req.params.toUserId

  WrapRequest.wrapDestroy req, res, next, conditions

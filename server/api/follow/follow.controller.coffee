
Follow = _u.getModel 'follow'
WrapRequest = new (require '../../utils/WrapRequest')(Follow)

exports.index = (req, res, next) ->
  conditions = {}
  conditions.from = req.query.fromUserId if req.query.fromUserId
  conditions.to   = req.query.toUserId if req.query.toUserId

  WrapRequest.wrapPageIndex req, res, next, conditions


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


exports.unfollow = (req, res, next) ->
  conditions =
    from: req.user._id
    to  : req.params.toUserId

  WrapRequest.wrapDestroy req, res, next, conditions

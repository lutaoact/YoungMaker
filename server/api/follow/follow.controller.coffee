
Follow = _u.getModel 'follow'
WrapRequest = new (require '../../utils/WrapRequest')(Follow)

exports.index = (req, res, next) ->
  conditions = {}
  conditions[req.query.key] = req.user._id
  WrapRequest.wrapPageIndex req, res, next, conditions


exports.follow = (req, res, next) ->
  data =
    from: req.user._id
    to  : req.params.toUserId

  WrapRequest.wrapCreate req, res, next, data


exports.unfollow = (req, res, next) ->
  conditions =
    from: req.user._id
    to  : req.params.toUserId

  WrapRequest.wrapDestroy req, res, next, conditions

'use strict'

Favorite = _u.getModel 'favorite'
WrapRequest = new (require '../../utils/WrapRequest')(Favorite)

exports.addOrRemove = (req, res, next) ->
  action = req.url.substr 1

  data = user: req.user._id, object: req.body.object, type: req.body.type

  Favorite.getByUserAndObject data.user, data.object
  .then (favorite) ->
    switch action
      when 'add'
        if favorite
          return Q.reject
            status: 400
            errCode: ErrCode.HasBeenHere
            errMsg: '已经收藏过了'
        else
          return Favorite.createQ data
      when 'remove'
        if favorite
          return favorite.removeQ()
        else
          return Q.reject
            status: 400
            errCode: ErrCode.HasNotBeenHere
            errMsg: '已经移出收藏'
      else
        return Q.reject
          status: 404
          errCode: ErrCode.IllegalPath
          errMsg: '非法路径'
  .then (doc) ->
    res.send doc
  .catch next
  .done()

"use strict"

Activity = _u.getModel 'activity'

exports.create = (req, res, next) ->
  user = req.user

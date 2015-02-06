"use strict"

express = require("express")
auth = require("../../auth/auth.service")
router = express.Router()
request = require 'request'

AodianyunUtils = _u.getUtils 'aodianyun'

router.post "/openThenStart", auth.isAuthenticated(), (req, res, next) ->
  classeId = req.body.classeId
  AodianyunUtils.getAppQ()
  .then (appids) ->
    if _u.contains appids, classeId
      AodianyunUtils.restartAppQ classeId
    else
      AodianyunUtils.openAppQ classeId
  .then () ->
    res.send result: 'ok'
  .catch next
  .done()

module.exports = router

"use strict"

express = require("express")
auth = require("../../auth/auth.service")
router = express.Router()
request = require 'request'

AodianyunUtils = _u.getUtils 'aodianyun'

router.post "/openThenStart", auth.isAuthenticated(), (req, res, next) ->
  classeId = req.body.classeId
  AodianyunUtils.openThenStart classeId
  .then () ->
    res.send result: 'ok'
  .catch next
  .done()

router.post "/close", auth.isAuthenticated(), (req, res, next) ->
  classeId = req.body.classeId
  AodianyunUtils.closeAppQ classeId
  .then () ->
    res.send result: 'ok'
  .catch next
  .done()

module.exports = router

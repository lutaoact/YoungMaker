"use strict"

express = require("express")

router = express.Router()

router.post "/", (req, res, next) ->

  loggerC.write req.headers.host, req.org?._id, JSON.stringify(req.body)
  res.send 200

module.exports = router

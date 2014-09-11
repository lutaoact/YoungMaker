"use strict"

express = require("express")
controller = require("./test.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.post "/socket", auth.isAuthenticated(), controller.socket

module.exports = router

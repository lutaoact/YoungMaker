"use strict"

express = require("express")
controller = require("./homework_stats.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.isAuthenticated(), controller.show

module.exports = router
"use strict"

express = require("express")
controller = require("./activity.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/:userId", auth.isAuthenticated(false), controller.index

module.exports = router

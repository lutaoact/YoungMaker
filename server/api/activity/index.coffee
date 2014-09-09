"use strict"

express = require("express")
controller = require("./activity.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.post "/", auth.isAuthenticated(), controller.create

module.exports = router

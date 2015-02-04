"use strict"

express = require("express")
controller = require("./follow.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.post "/",   auth.isAuthenticated(), controller.follow
router.post "/un", auth.isAuthenticated(), controller.unfollow

module.exports = router

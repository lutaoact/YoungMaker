"use strict"

express = require("express")
controller = require("./follow.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get  "/",            auth.isAuthenticated(), controller.index #?fromUserId=xxx[&toUserId=xxxx]
router.get  "/:toUserId",   auth.isAuthenticated(), controller.show
router.post   "/",          auth.isAuthenticated(), controller.follow
router.delete "/:toUserId", auth.isAuthenticated(), controller.unfollow

module.exports = router

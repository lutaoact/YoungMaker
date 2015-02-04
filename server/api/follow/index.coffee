"use strict"

express = require("express")
controller = require("./follow.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get  "/",             auth.isAuthenticated(), controller.index #?key=[from/to]
router.get  "/:toUserId",    auth.isAuthenticated(), controller.show  #?key=[from/to]
router.post "/:toUserId",    auth.isAuthenticated(), controller.follow
router.post "/un/:toUserId", auth.isAuthenticated(), controller.unfollow

module.exports = router

"use strict"

express = require("express")
controller = require("./keypoint_stats.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/my_view", auth.isAuthenticated(), controller.myView
router.get "/student", auth.hasRole("student"), controller.studentView

module.exports = router

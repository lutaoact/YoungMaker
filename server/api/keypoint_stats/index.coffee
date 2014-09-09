"use strict"

express = require("express")
controller = require("./keypoint_stats.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get '/', auth.isAuthenticated(), controller.show #?courseId=xxxx[&studentId=xxxx]

module.exports = router

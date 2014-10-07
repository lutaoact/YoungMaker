"use strict"

express = require("express")
controller = require("./lecture_stats.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.hasRole('teacher'), controller.questionStats #?courseId=xxxx&lectureId=xxxx[&classId=xxxx]

module.exports = router
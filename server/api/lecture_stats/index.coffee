"use strict"

express = require("express")
controller = require("./lecture_stats.controller")
auth = require("../../auth/auth.service")
router = express.Router()

# courseId or classId is used to get students list.
router.get "/", auth.hasRole('teacher'), controller.questionStats #?courseId=xxxx[or &classId=xxxx]&lectureId=xxxx&questionId=xxxx

module.exports = router

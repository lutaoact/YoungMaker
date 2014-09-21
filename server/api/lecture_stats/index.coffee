"use strict"

express = require("express")
controller = require("./lecture_stats.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/:id", auth.hasRole('teacher'), controller.questionStats

module.exports = router
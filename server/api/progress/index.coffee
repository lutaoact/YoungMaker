"use strict"

express = require("express")
controller = require("./progress.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.isAuthenticated(), controller.show #courseId=xxxxx&[classeId=yyyy]

module.exports = router

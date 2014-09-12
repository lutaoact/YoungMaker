"use strict"

express = require("express")
controller = require("./school.controller")
auth = require("../../auth/auth.service")
router = express.Router()

# course
router.get "/", controller.show

module.exports = router

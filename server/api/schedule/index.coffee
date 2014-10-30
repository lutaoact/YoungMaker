"use strict"

express = require("express")
controller = require("./schedule.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.isAuthenticated(), controller.index
router.post "/", auth.hasRole('teacher'), controller.create
router.put "/", auth.hasRole('admin'), controller.upsert

module.exports = router

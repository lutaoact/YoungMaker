"use strict"

express = require("express")
controller = require("./banner.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", controller.index
router.post "/", auth.hasRole('admin'), controller.create
router.put "/:id", auth.hasRole('admin'), controller.update
router.delete "/:id", auth.hasRole('admin'), controller.destroy

module.exports = router

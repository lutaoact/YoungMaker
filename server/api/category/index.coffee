"use strict"

express = require("express")
controller = require("./category.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.isAuthenticated(), controller.index
router.post "/", auth.hasRole("admin"), controller.create
router.patch "/:id", auth.hasRole("admin"), controller.update
router.delete "/:id", auth.hasRole("admin"), controller.destroy
router.post "/multiDelete", auth.hasRole("admin"), controller.multiDelete

module.exports = router

"use strict"

express = require("express")
controller = require("./organization.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.hasRole("admin"), controller.index
router.get "/me", auth.isAuthenticated(), controller.me
router.get "/:id", auth.hasRole("admin"), controller.show
router.post "/", auth.hasRole("admin"), controller.create
router.put "/:id", auth.hasRole("admin"), controller.update
router.patch "/:id", auth.hasRole("admin"), controller.update
router.delete "/:id", auth.hasRole("admin"), controller.destroy

module.exports = router

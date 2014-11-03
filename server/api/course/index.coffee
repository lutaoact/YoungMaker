"use strict"

express = require("express")
controller = require("./course.controller")
auth = require("../../auth/auth.service")
router = express.Router()

# course
router.get "/",       auth.isAuthenticated(), controller.index
router.get "/:id",    auth.isAuthenticated(), controller.show
router.post "/",      auth.hasRole("admin"),  controller.create
router.put "/:id",    auth.isAuthenticated(), controller.update
router.patch "/:id",  auth.isAuthenticated(), controller.update
router.delete "/:id", auth.hasRole("admin"),  controller.destroy

module.exports = router

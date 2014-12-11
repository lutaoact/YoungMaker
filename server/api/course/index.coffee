"use strict"

express = require("express")
controller = require("./course.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/",       controller.index
router.get "/:id",    controller.show
router.post "/",      auth.isAuthenticated(), controller.create
router.put "/:id",    auth.isAuthenticated(), controller.update
router.patch "/:id",  auth.isAuthenticated(), controller.update
router.delete "/:id", auth.isAuthenticated(), controller.destroy

#扩展api
router.post "/:id/like", auth.isAuthenticated(), controller.like

module.exports = router

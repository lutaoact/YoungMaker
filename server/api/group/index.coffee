"use strict"

express = require("express")
controller = require("./group.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/",       controller.index
router.get "/:id",    controller.show
router.post "/",      auth.isAuthenticated(), controller.create
router.put "/:id",    auth.isAuthenticated(), controller.update
router.patch "/:id",  auth.isAuthenticated(), controller.update
router.delete "/:id", auth.isAuthenticated(), controller.destroy

#扩展
router.post "/:id/join",   auth.isAuthenticated(), controller.joinOrLeave
router.post "/:id/leave",  auth.isAuthenticated(), controller.joinOrLeave
router.get "/:id/members", controller.showMembers
router.get "/:id/getRole", auth.isAuthenticated(), controller.getRole

module.exports = router

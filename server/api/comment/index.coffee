"use strict"

express = require("express")
controller = require("./comment.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", controller.index #?type=x&belongTo=xxxxx
router.post "/", auth.isAuthenticated(), controller.create
router.put "/:id", auth.isAuthenticated(), controller.update
router.delete "/:id", auth.isAuthenticated(), controller.destroy

#扩展api
router.post "/:id/like", auth.isAuthenticated(), controller.like

module.exports = router

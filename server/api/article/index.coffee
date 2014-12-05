"use strict"

express = require("express")
controller = require("./article.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", controller.index
router.get "/:id", controller.show
router.post "/", auth.isAuthenticated(), controller.create
router.put "/:id", auth.isAuthenticated(), controller.update
router.delete "/:id", auth.isAuthenticated(), controller.destroy

module.exports = router

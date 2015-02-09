"use strict"

express = require("express")
controller = require("./category.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", controller.index
router.post "/", auth.hasRole("admin"), controller.create
router.get "/:id/courses", auth.hasRole("admin"), controller.courses
router.put "/:id", auth.hasRole("admin"), controller.update
router.patch "/:id", auth.hasRole("admin"), controller.update
router.delete "/:id", auth.hasRole("admin"), controller.destroy
router.post "/multiDelete", auth.hasRole("admin"), controller.multiDelete

module.exports = router

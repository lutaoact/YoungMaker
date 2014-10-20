"use strict"

express = require("express")
controller = require("./classe.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.hasRole('teacher'), controller.index
router.get "/:id", auth.hasRole('teacher'), controller.show
router.get "/:id/students", auth.hasRole("teacher"), controller.showStudents
router.post "/", auth.hasRole("admin"), controller.create
router.put "/:id", auth.hasRole("admin"), controller.update
router.patch "/:id", auth.hasRole("admin"), controller.update
router.delete '/:id', auth.hasRole('admin'), controller.destroy
router.post "/multiDelete", auth.hasRole("admin"), controller.multiDelete

module.exports = router

"use strict"

express = require("express")
controller = require("./class_progress.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/:id", controller.show
router.post "/", auth.hasRole("teacher"), controller.create
router.put "/:id", auth.hasRole("teacher"), controller.update
router.patch "/:id", auth.hasRole("teacher"), controller.update
router.delete "/:id", auth.hasRole("teacher"), controller.destroy
#router.get('/', controller.index)

module.exports = router

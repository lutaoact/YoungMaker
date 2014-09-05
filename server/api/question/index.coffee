"use strict"

express = require("express")
controller = require("./question.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.hasRole('teacher'), controller.index
router.get "/:id", auth.hasRole('teacher'), controller.show
router.post "/", auth.hasRole("teacher"), controller.create
router.put "/:id", auth.hasRole("teacher"), controller.update
router.patch "/:id", auth.hasRole("teacher"), controller.update
router.delete '/:id', auth.hasRole('teacher'), controller.destroy
router.post "/quiz", auth.hasRole("teacher"), controller.pubQuiz

module.exports = router

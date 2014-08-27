"use strict"

express = require("express")
controller = require("./key_point.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.hasRole("teacher"), controller.index
router.get "/:id", auth.hasRole("teacher"), controller.show
router.post "/", auth.hasRole("teacher"), controller.create
#router.delete "/:id", auth.hasRole("teacher"), controller.destroy

router.get "/search/:name", auth.hasRole("teacher"), controller.searchByKeyword

module.exports = router

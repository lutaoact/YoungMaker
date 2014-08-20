"use strict"

express = require("express")
controller = require("./knowledge_point.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", controller.index
router.get "/:id", controller.show
router.post "/", auth.hasRole("teacher"), controller.create
router["delete"] "/:id", auth.hasRole("teacher"), controller.destroy
#router.put('/:id', controller.update);
#router.patch('/:id', controller.update);

module.exports = router


"use strict"

express = require("express")
controller = require("./discussion.controller")
auth = require("../../auth/auth.service")
router = express.Router()

# discussions
router.get '/', auth.isAuthenticated(), controller.index
router.post '/', auth.isAuthenticated(), controller.create
router.put '/', auth.isAuthenticated(), controller.update
router.patch '/', auth.isAuthenticated(), controller.update
router.delete '/:id', auth.isAuthenticated(), controller.destroy
router.post '/:id/votes', auth.isAuthenticated(), controller.vote #up: {"vote: 1"}, down:{"vote: 1"}


module.exports = router

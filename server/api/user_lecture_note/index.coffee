"use strict"

express = require("express")
controller = require("./user_lecture_note.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/",       auth.isAuthenticated(), controller.index
router.get "/:id",    auth.isAuthenticated(), controller.show
router.post "/",      auth.isAuthenticated(), controller.create
router.put "/:id",    auth.isAuthenticated(), controller.update
router.patch "/:id",  auth.isAuthenticated(), controller.update
router.delete '/:id', auth.isAuthenticated(), controller.destroy

module.exports = router

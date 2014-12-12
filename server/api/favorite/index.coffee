'use strict'

express = require("express")
controller = require("./favorite.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.post "/add", auth.isAuthenticated(), controller.addOrRemove
router.post "/remove", auth.isAuthenticated(), controller.addOrRemove

module.exports = router

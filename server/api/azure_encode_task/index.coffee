'use strict'

express = require 'express'
controller = require './azure_encode_task.controller'
auth = require '../../auth/auth.service'

router = express.Router()

# image request will not send Authorization in header, thus, auth.isAuthenticated() fails. Consider using cookie.
router.post  '/', auth.isAuthenticated(), controller.create
router.get '/status', auth.isAuthenticated(), controller.status # ?inputAssetId=***

module.exports = router

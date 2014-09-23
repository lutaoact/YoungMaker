'use strict'

express = require 'express'
controller = require './demo.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/clear', auth.hasRole('admin'), controller.clear
router.get '/user', controller.getUser

module.exports = router

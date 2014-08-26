'use strict'

express = require 'express'
controller = require './slide.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.post '/:key', auth.hasRole('teacher'), controller.process

module.exports = router
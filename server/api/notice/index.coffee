'use strict'

express = require 'express'
controller = require './notice.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/', auth.isAuthenticated(), controller.index

module.exports = router

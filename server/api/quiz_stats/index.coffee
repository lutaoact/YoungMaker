'use strict'

express = require 'express'
controller = require './quiz_stats.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/my_view', auth.isAuthenticated(), controller.myView
router.get '/teacher', auth.hasRole('teacher'), controller.studentView

module.exports = router

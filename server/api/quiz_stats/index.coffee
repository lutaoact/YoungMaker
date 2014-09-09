'use strict'

express = require 'express'
controller = require './quiz_stats.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/', auth.isAuthenticated(), controller.show #?courseId=xxxx[&studentId=xxxx]
router.get '/real_time', auth.hasRole('teacher'), controller.realTimeView

module.exports = router

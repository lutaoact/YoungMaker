'use strict'

express = require 'express'
controller = require './slide.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/teacher', auth.hasRole('teacher'), controller.teacherView
router.get '/student', auth.hasRole('student'), controller.studentView

module.exports = router

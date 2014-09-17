'use strict'

express = require 'express'
controller = require './quiz_answer.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/', auth.hasRole('teacher'), controller.index
router.get '/:id', auth.isAuthenticated(), controller.show
router.put '/', auth.hasRole('student'), controller.update
router.delete '/:id', auth.hasRole('teacher'), controller.destroy
router.delete '/', auth.hasRole('teacher'), controller.deleteByLectureId

module.exports = router

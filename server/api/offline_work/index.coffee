'use strict'

express = require 'express'
controller = require './offline_work.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/', auth.isAuthenticated(), controller.index #lectureId=xxxx
router.get '/:id', auth.isAuthenticated(), controller.show
router.put '/:id', auth.hasRole('student'), controller.update
router.post '/', auth.hasRole('student'), controller.create #lectureId=xxxx
router.post '/:id/score', auth.hasRole('teacher'), controller.giveScore
router.delete '/:id', auth.hasRole('teacher'), controller.destroy

module.exports = router

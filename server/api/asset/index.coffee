'use strict'

express = require 'express'
controller = require './asset.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get  '/images/*', auth.isAuthenticated(), controller.getImages
router.get  '/videos/*', auth.isAuthenticated(), controller.getVideos
router.get  '/slides/*', auth.isAuthenticated(), controller.getSlides
router.post '/', auth.isAuthenticated(), controller.upload

module.exports = router

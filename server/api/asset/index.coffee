'use strict'

express = require 'express'
controller = require './asset.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get  '/images/*', auth.isAuthenticated(), controller.getImages
router.get  '/videos/*', auth.isAuthenticated(), controller.getVideos
router.get  '/slides/*', auth.isAuthenticated(), controller.getSlides
router.get  '/upload/images', auth.isAuthenticated(), controller.uploadImage
router.get  '/upload/videos', auth.isAuthenticated(), controller.uploadVideo
router.get  '/upload/slides', auth.isAuthenticated(), controller.uploadSlide

module.exports = router

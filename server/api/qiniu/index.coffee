'use strict'

qiniu = require 'qiniu'
express = require 'express'
controller = require './qiniu_controller'
config = require '../../config/environment'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/uptoken', auth.isAuthenticated(), controller.uptoken
router.get '/signed_url/:key', auth.isAuthenticated(), controller.signedUrl
router.get '/download/:key', auth.isAuthenticated(), controller.downloadFile
router.post '/upload', auth.isAuthenticated(), controller.uploadFile
router.post '/pfop_notify/:type', controller.receiveNotify

module.exports = router


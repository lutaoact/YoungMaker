'use strict'

qiniu = require 'qiniu'
express = require 'express'
controller = require './qiniu_controller'
config = require '../../config/environment'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/uptoken', auth.isAuthenticated(), controller.uptoken
router.get '/signedUrl/:key', auth.isAuthenticated(), controller.signedUrl

module.exports = router

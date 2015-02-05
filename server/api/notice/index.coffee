'use strict'

express = require 'express'
controller = require './notice.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/', auth.isAuthenticated(), controller.index
router.post '/read', auth.isAuthenticated(), controller.read #body => {ids: []}
router.get '/unreadCount', auth.isAuthenticated(), controller.unreadCount

module.exports = router

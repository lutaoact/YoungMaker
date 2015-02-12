'use strict'

express = require 'express'
controller = require './user.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/', auth.hasRole('admin'), controller.index
router.get '/recommends', controller.recommends
router.get '/me', auth.isAuthenticated(), controller.me
router.get '/check', controller.check #?email=xxxxx
router.get '/states', controller.states #?userId=xxx
router.delete '/:id', auth.hasRole('admin'), controller.destroy
router.post '/multiDelete', auth.hasRole('admin'), controller.multiDelete
router.post '/forgotPassword', controller.forgotPassword
router.post '/resetPassword', controller.resetPassword
router.put '/:id/password', auth.isAuthenticated(), controller.changePassword
router.put '/:id', auth.isAuthenticated(), controller.update
router.patch '/:id', auth.isAuthenticated(), controller.update
router.get '/:id', controller.show
router.post '/', controller.create
router.post '/bulk', auth.hasRole('admin'), controller.bulkImport
router.get '/emails/:email', auth.isAuthenticated(), controller.showByEmail

module.exports = router

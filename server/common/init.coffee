global._  = require 'lodash'
global._s = require 'underscore.string'
global.socketMap = {}
global._u = require './util'
global.BaseUtils = require './BaseUtils'
global.ErrCode = require './ErrCode'

process.env.NODE_ENV = process.env.NODE_ENV || 'development'
global.config = require '../config/environment'
global.logger = require('./logger').logger
global.loggerD = require('./logger').loggerD
global.LogUtils = _u.getUtils 'log'
global.Q = require 'q'
global.Const = require './Const'

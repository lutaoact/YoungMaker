'use strict'

path = require 'path'
_ = require 'lodash'

requiredProcessEnv = (name) ->
  if not process.env[name]
    throw new Error 'You must set the ' + name + ' environment variable'
  process.env[name]

# All configurations will extend these options
# ============================================
all =
  appName: 'maui'

  env: process.env.NODE_ENV

  weixinAuth:
    appkey: 'wx0b867034fb0d7f4e'
    secret: '7b88d10a6a284fc9dc3881e5d32396ed'
    oauth_callback_url: 'http://cloud3edu.cloud3edu.cn/auth/weixin/callback'

  # Root path of server
  root: path.normalize __dirname + '/../../..'

  # Server port
  port: process.env.PORT or 9001

  # Should we populate the DB with sample data?
  seedDB: false

  # Secret for session
  secrets:
    session: process.env.EXPRESS_SECRET or 'maui-secret'

  # List of user roles
  userRoles: ['user', 'editor', 'admin']

  # MongoDB connection options
  mongo:
    options:
      db:
        safe: true

# Export the config object based on the NODE_ENV
# ==============================================
module.exports = _.merge all, require('./' + process.env.NODE_ENV) or {}

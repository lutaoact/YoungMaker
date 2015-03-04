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
    appkey: 'wxda486048345cc138'
    secret: '46c0c8a212792bb25fd42a1a995bafbd'
    oauth_callback_url: 'http://youngmakers.cn/auth/weixin/callback'

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

'use strict'

# Development specific configuration
# ==================================
module.exports =
  # MongoDB connection options
  mongo:
    uri: 'mongodb://localhost/budweiser-dev'

  # Qiniu access_key and secret_key
  qiniu:
    access_key : '_NXt69baB3oKUcLaHfgV5Li-W_LQ-lhJPhavHIc_'
    secret_key  : 'qpIv4pTwAQzpZk6y5iAq14Png4fmpYAMsdevIzlv'
    domain : 'temp-cloud3edu-com.qiniudn.com'
    bucket_name : 'temp-cloud3edu-com'
    signed_url_expires : 24 * 60 * 60
  logger:
    path: '/data/log/budweiser.log'
    level: 'DEBUG'

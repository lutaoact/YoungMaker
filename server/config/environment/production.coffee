'use strict'

# Production specific configuration
# =================================
module.exports =
  # Server IP
  ip : process.env.OPENSHIFT_NODEJS_IP or
            process.env.IP or
            undefined

  # Server port
  port : process.env.OPENSHIFT_NODEJS_PORT or
            process.env.PORT or
            9000

  # MongoDB connection options
  mongo :
    uri : process.env.MONGOLAB_URI or
           process.env.MONGOHQ_URL or
           process.env.OPENSHIFT_MONGODB_DB_URL+process.env.OPENSHIFT_APP_NAME or
            'mongodb://vm2mongo.wckvrx.pek2.qingcloud.com/budweiser'

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

  local:
    tempDir : '/data/temp_node_dir'

  nodejsServer : '119.254.110.62'



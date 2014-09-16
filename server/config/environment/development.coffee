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

  aws:
    accessKeyId : 'AKIAOQO4QDXGFY3APFBQ'
    secretAccessKey : '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'
    region : 'cn-north-1'
    slideBucket : 'slides.cloud3edu.cn'
    algorithm : 'AWS4-HMAC-SHA256'

  logger:
    path: '/data/log/budweiser.log'
    level: 'DEBUG'

  local:
    tempDir : '/temp_node_dir'

  nodejsServer : '115.29.244.232'

  assetHost :
    images : 'qiniu'
    slides : 's3' # change to S3 later
    videos : 'qiniu'
    uploadImage : 'qiniu'
    uploadSlide : 's3' # change to S3 later
    uploadVideo : 'qiniu'

  redis :
    port : 6379
    host : "localhost"
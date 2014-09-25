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

  aws:
    accessKeyId : 'AKIAOQO4QDXGFY3APFBQ'
    secretAccessKey : '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'
    region : 'cn-north-1'
    slideBucket : 'slides.cloud3edu.cn'
    slideUploadBucket: 'temp.cloud3edu.cn'
    algorithm : 'AWS4-HMAC-SHA256'

  azure:
    accountName: 'trymedia'
    accountKey: 'HQVc3/yjrl8QDw7/NKvnbG2/jFmN7mJ++75xunlVD+M='
    acsBaseAddress: "https://wamsprodglobal001acs.accesscontrol.chinacloudapi.cn/v2/OAuth2-13"
    bjbAPIServerAddress: 'https://wamsshaclus001rest-hs.chinacloudapp.cn/API/'
    shaAPIServerAddress: 'https://wamsbjbclus001rest-hs.chinacloudapp.cn/API/'
    signed_url_expires : 24 * 60 # in minutes
    defaultHeaders : (access_token)->
      Accept: 'application/json;odata=verbose'
      DataServiceVersion: '3.0'
      MaxDataServiceVersion: '3.0'
      'x-ms-version': '2.5'
      'Content-Type': 'application/json;odata=verbose'
      Authorization: 'Bearer '+access_token

  logger:
    path: '/data/log/budweiser.log'
    level: 'DEBUG'

  local:
    tempDir : '/data/temp_node_dir'

  nodejsServer : '119.254.110.62'

  assetHost :
    images : 'qiniu'
    slides : 's3' # change to S3 later
    videos : 'azure'
    uploadImage : 'qiniu'
    uploadSlide : 's3' # change to S3 later
    uploadVideo : 'azure'

  redis :
    port : 6379
    host : process.env.MONGOLAB_URI or 'vm4redis.wckvrx.pek2.qingcloud.com'

#  proxy :
#    'http://vmnodebase.wckvrx.pek2.qingcloud.com:8081'
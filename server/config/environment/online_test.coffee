'use strict'

# Development specific configuration
# ==================================
module.exports =
  # MongoDB connection options
  mongo:
    uri: 'mongodb://localhost/budweiser'

  logger:
    path: '/data/log/budweiser.log'
    level: 'DEBUG'

  local:
    tempDir : '/temp_node_dir'

  nodejsServer : '115.29.244.232'

  assetHost :
    images : 'qiniu'
    slides : 's3' # change to S3 later
    videos : 'azure'
    uploadImage : 'qiniu'
    uploadSlide : 's3' # change to S3 later
    uploadVideo : 'azure'

  redis :
    port : 6379
    host : "localhost"

# Qiniu access_key and secret_key
  qiniu:
    access_key : '_NXt69baB3oKUcLaHfgV5Li-W_LQ-lhJPhavHIc_'
    secret_key  : 'qpIv4pTwAQzpZk6y5iAq14Png4fmpYAMsdevIzlv'
    signed_url_expires : 24 * 60 * 60

  s3:
    accessKeyId : 'AKIAOQO4QDXGFY3APFBQ'
    secretAccessKey : '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'
    region : 'cn-north-1'
    algorithm : 'AWS4-HMAC-SHA256'

  azure:
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

  assetHost :
    uploadImageType : '0'
    uploadSlideType : '1'
    uploadVideoType : '2'
    uploadFileType : '0'

  assetsConfig:
    0:
      serviceName: 'qiniu'
      domain : 'temp-cloud3edu-com.qiniudn.com'
      bucket_name : 'temp-cloud3edu-com'
    1:
      serviceName: 's3'
      slideBucket : 'slides.cloud3edu.cn'
      slideUploadBucket: 'temp.cloud3edu.cn'
    2:
      serviceName: 'azure'
      accountName: 'trymedia'
      accountKey: 'HQVc3/yjrl8QDw7/NKvnbG2/jFmN7mJ++75xunlVD+M='

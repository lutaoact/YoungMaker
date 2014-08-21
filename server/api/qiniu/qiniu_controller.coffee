qiniu = require 'qiniu'
config = require '../../config/environment'
randomstring = require 'randomstring'
cache = require 'memory-cache'
path = require 'path'
fs = require 'fs'
http = require 'http'
mediaEvents = require '../../common/media_process_event'

qiniu.conf.ACCESS_KEY = config.qiniu.access_key
qiniu.conf.SECRET_KEY = config.qiniu.secret_key
domain                       = config.qiniu.domain
bucketName                = config.qiniu.bucket_name
signedUrlExpires          = config.qiniu.signed_url_expires
tempDir = config.local.tempDir

###
  return qiniu upload token
###
exports.uptoken = (req, res) ->
  putPolicy = new qiniu.rs.PutPolicy bucketName

  token = putPolicy.token()
  randomDirName = randomstring.generate 10

  res.json 200,
    random : randomDirName
    token : token

###
  return qiniu signed URL for download from private bucket
###
exports.signedUrl = (req, res) ->
  key = req.params.key

  cached = cache.get key
  if cached
    return res.send 200, cached

  baseUrl = qiniu.rs.makeBaseUrl domain, key
  policy = new qiniu.rs.GetPolicy(signedUrlExpires)
  downloadUrl = policy.makeRequest(decodeURIComponent(baseUrl))

  # cache expiration is one hour less than signedURL expiration from qiniu
  cache.put key, downloadUrl,  (signedUrlExpires-60*60)*1000

  res.send 200, downloadUrl

# receive pfop notify from qiniu service
exports.receiveNotify = (req, res) ->
  type = req.params.type
  console.log "notify type is #{type}"
  result = req.body

  ## send 200 to qiniu so it won't keep posting notify
  res.send 200

  if result.code isnt 0
    console.error "Qiniu media process #{type} failed"
    return

  switch type
    when 'ppt2pdf' then mediaEvents.mediaProcess.emit 'ppt2pdf', result.items[0].key
    when 'pdf2img' then mediaEvents.mediaProcess.emit 'pdf2img', result.items[0].key
    else console.error "Unknown process type"


# upload file to qiniu
exports.uploadFile = (req, res) ->
  localFile = req.body.localFile
  # remove file directory part
  fileName = path.basename localFile

  # create key by prepend random string to localFile name
  randomDirName = randomstring.generate 10
  key = randomDirName + '/' + fileName

  putPolicy = new qiniu.rs.PutPolicy bucketName
  upToken = putPolicy.token()
  extra = new qiniu.io.PutExtra()
  qiniu.io.putFile upToken, key, localFile, extra, (err, ret) ->
    if err
      console.error err
      res.send 500
    else
      console.log ret.key + ':' + ret.hash
      res.send 200

# download file from qiniu
exports.downloadFile = (req, res) ->
  key = req.params.key
  console.log 'Resource key is ' + key
  baseUrl = qiniu.rs.makeBaseUrl domain, key
  policy = new qiniu.rs.GetPolicy()
  downloadUrl = policy.makeRequest baseUrl

  file = fs.createWriteStream tempDir+'/'+encodeURIComponent(key)
  http.get downloadUrl, (response) ->
    response.pipe file
    res.send 200

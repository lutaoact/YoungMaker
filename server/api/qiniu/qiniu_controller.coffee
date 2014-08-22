'use strict'

qiniu = require 'qiniu'
config = require '../../config/environment'
randomstring = require 'randomstring'
cache = require 'memory-cache'

qiniu.conf.ACCESS_KEY = config.qiniu.access_key
qiniu.conf.SECRET_KEY = config.qiniu.secret_key
domain                       = config.qiniu.domain
bucketName                = config.qiniu.bucket_name
signedUrlExpires          = config.qiniu.signed_url_expires


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

  baseUrl = qiniu.rs.makeBaseUrl domain, key.split('?')[0]
  # the query should not encode before signature
  baseUrl += if key.split('?')[1] then ('?' + key.split('?')[1]) else ''
  policy = new qiniu.rs.GetPolicy(signedUrlExpires)
  downloadUrl = policy.makeRequest(baseUrl)
  # cache expiration is one hour less than signedURL expiration from qiniu
  cache.put key, downloadUrl,  (signedUrlExpires-60*60)*1000

  res.send 200, downloadUrl

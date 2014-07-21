'use strict'

qiniu = require 'qiniu'
config = require '../../config/environment'
randomstring = require 'randomstring'

qiniu.conf.ACCESS_KEY = config.qiniu.access_key
qiniu.conf.SECRET_KEY = config.qiniu.secret_key
domain                       = config.qiniu.domain
bucketName                = config.qiniu.bucket_name


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

  key = decodeURIComponent req.params.key
  console.log 'key is ' + key

  baseUrl = qiniu.rs.makeBaseUrl domain, key
  policy = new qiniu.rs.GetPolicy()
  downloadUrl = policy.makeRequest(decodeURIComponent(baseUrl))

  res.send 200, downloadUrl

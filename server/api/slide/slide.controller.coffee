http = require 'http'
querystring = require 'querystring'
qiniu = require 'qiniu'
config = require '../../config/environment'
mediaEvents = require '../../common/media_process_event'

density = 150
quality = 80
resize = 800

domain = config.qiniu.domain
accessKey = config.qiniu.access_key
secretKey = config.qiniu.secret_key
saveBucket = config.qiniu.bucket_name
nodejsServer = config.nodejsServer

slideProcessStatus = {}

## make download url with token and expiration for given key
makeDownloadUrl = (key) ->
  baseUrl = qiniu.rs.makeBaseUrl domain, key
  policy = new qiniu.rs.GetPolicy()
  downloadUrl = policy.makeRequest(decodeURIComponent(baseUrl))

## Make access token for given signing string
makeAccessToken = (signingStr) ->
  sign = qiniu.util.hmacSha1 signingStr, secretKey
  encodedSign = qiniu.util.base64ToUrlSafe sign
  accessToken = 'QBox ' + accessKey + ':' + encodedSign

## Make saveas string for given key
makeSaveasStr = (key) ->
  entryURI = saveBucket + ':' + key
  encodedEntryURI = qiniu.util.urlsafeBase64Encode entryURI
  saveasStr = '|saveas/' + encodedEntryURI

# get page number of generated pdf
cvtPdf2Img = (pdfKey, res) ->

  console.log 'pdfKey is ' + pdfKey

  downloadUrl = makeDownloadUrl pdfKey+'?odconv/jpg/info'

  http.get downloadUrl, (response) ->
    if response.statusCode isnt 200
      console.err 'Failed to get generated PDF file info'
      return res.json 500

    response.setEncoding 'utf8'
    response.on 'data', (chunk) ->

      pageNum = JSON.parse(chunk).page_num
      console.log 'Page num is ' + JSON.parse(chunk).page_num


      ## for each page, send pfop request
      fileName = pdfKey.replace /\.pdf$/i, ''

      if not slideProcessStatus[fileName]?
        console.error "Cannot find #{fileName} entry in slideProcessStatus"
        return res.json 500

      ## add entry to slide process status
      slideProcessStatus[fileName].imgKeys = []
      slideProcessStatus[fileName].total = pageNum
      slideProcessStatus[fileName].counter = 0

      for i in [1..pageNum]

        saveKey = fileName + '-slide-' + i + '.jpg'

        saveasStr = makeSaveasStr saveKey

        params =
          bucket : saveBucket
          key    : pdfKey
          fops   : 'odconv/jpg/page/' + i + '/density/' + density +
            '/quality/' + quality + '/resize/' + resize + saveasStr
          pipeline : 'testppt'
          notifyURL : "http://#{nodejsServer}/api/qiniu/pfop_notify/pdf2img"

        reqBody = querystring.stringify params

        signingStr = "/pfop/\n" + reqBody

        accessToken = makeAccessToken(signingStr)

        options =
          hostname : 'api.qiniu.com'
          path : '/pfop/'
          method : 'POST'
          headers :
            Host : 'api.qiniu.com'
            'Content-Type' : 'application/x-www-form-urlencoded'
            Authorization : accessToken

        # send http request
        pfopReq = http.request options, (response) ->
          console.log 'STATUS:' + response.statusCode
          if response.statusCode isnt 200
            console.error "Qiniu failed to process PPT file"
            return res.json response.statusCode

        console.log 'Sending pdf2image processing request, page num ' + i
        pfopReq.write reqBody, 'utf8'
        pfopReq.end()
        pfopReq.on 'error', (e) ->
          console.log 'Failed to process ppt ' + e
          res.json 500, e

###
  Use qiniu cloud service to process PPT file and
  return list resource keys of generated static images
###
exports.process = (req, res) ->
  pptKey = req.params.key
  console.log 'PPT key is ' + pptKey

  pdfKey = pptKey.replace /(ppt|pptx)$/i, 'pdf'
  fileName = pptKey.replace /\.(ppt|pptx)$/i, ''

  console.log 'PDF key is ' + pdfKey

  saveasStr = makeSaveasStr pdfKey

  params =
    bucket : saveBucket
    key    : pptKey
    fops   : 'odconv/pdf'+saveasStr
    pipeline : 'testppt'
    notifyURL : "http://#{nodejsServer}/api/qiniu/pfop_notify/ppt2pdf"

  reqBody = querystring.stringify params
  console.log 'ReqBody is ' + reqBody

  signingStr = "/pfop/\n" + reqBody

  accessToken = makeAccessToken(signingStr)

  options =
    hostname : 'api.qiniu.com'
    path : '/pfop/'
    method : 'POST'
    headers :
      Host : 'api.qiniu.com'
      'Content-Type' : 'application/x-www-form-urlencoded'
      Authorization : accessToken

  # send http request
  pfopReq = http.request options, (response) ->
    console.log 'STATUS:' + response.statusCode
    if response.statusCode isnt 200
      console.error "Qiniu failed to process PPT file"
      return res.json response.statusCode
    else
      # store res into global slide process status object
      slideProcessStatus[fileName] = {}
      slideProcessStatus[fileName].response = res

  pfopReq.write reqBody, 'utf8'

  pfopReq.end()

  pfopReq.on 'error', (e) ->
    console.log 'Failed to process ppt ' + e
    res.json 500, e


## listen to ppt2pdf event and call cvtPdf2Img
mediaEvents.mediaProcess.on 'ppt2pdf', (key) ->
  # find response obj from slideProcessStatus
  fileName = key.replace /\.pdf$/i, ''
  response = slideProcessStatus[fileName].response

  cvtPdf2Img key, response


## listen to pdf2img event and store key into key array
## when all slides are processed, send response to client
mediaEvents.mediaProcess.on 'pdf2img', (key) ->
  console.log 'Received pdf2img event, image key is ' + key

  fileName = key.replace /-slide-[0-9]+\.jpg$/i, ''
  entry = slideProcessStatus[fileName]

  if not entry?
    console.error "Cannot find entry for filename #{fileName}"
    return

  entry.counter++
  entry.imgKeys.push key
  if entry.counter is entry.total
    entry.response.json 200, entry.imgKeys
    delete slideProcessStatus[fileName]
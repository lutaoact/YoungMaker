(function() {
  var accessKey, config, cvtPdf2Img, density, domain, http, makeAccessToken, makeDownloadUrl, makeSaveasStr, mediaEvents, nodejsServer, qiniu, quality, querystring, resize, saveBucket, secretKey, slideProcessStatus;

  http = require('http');

  querystring = require('querystring');

  qiniu = require('qiniu');

  config = require('../../config/environment');

  mediaEvents = require('../../common/media_process_event');

  density = 150;

  quality = 80;

  resize = 800;

  domain = config.qiniu.domain;

  accessKey = config.qiniu.access_key;

  secretKey = config.qiniu.secret_key;

  saveBucket = config.qiniu.bucket_name;

  nodejsServer = config.nodejsServer;

  slideProcessStatus = {};

  makeDownloadUrl = function(key) {
    var baseUrl, downloadUrl, policy;
    baseUrl = qiniu.rs.makeBaseUrl(domain, key);
    policy = new qiniu.rs.GetPolicy();
    return downloadUrl = policy.makeRequest(decodeURIComponent(baseUrl));
  };

  makeAccessToken = function(signingStr) {
    var accessToken, encodedSign, sign;
    sign = qiniu.util.hmacSha1(signingStr, secretKey);
    encodedSign = qiniu.util.base64ToUrlSafe(sign);
    return accessToken = 'QBox ' + accessKey + ':' + encodedSign;
  };

  makeSaveasStr = function(key) {
    var encodedEntryURI, entryURI, saveasStr;
    entryURI = saveBucket + ':' + key;
    encodedEntryURI = qiniu.util.urlsafeBase64Encode(entryURI);
    return saveasStr = '|saveas/' + encodedEntryURI;
  };

  cvtPdf2Img = function(pdfKey, res) {
    var downloadUrl;
    console.log('pdfKey is ' + pdfKey);
    downloadUrl = makeDownloadUrl(pdfKey + '?odconv/jpg/info');
    return http.get(downloadUrl, function(response) {
      if (response.statusCode !== 200) {
        console.err('Failed to get generated PDF file info');
        return res.json(500);
      }
      response.setEncoding('utf8');
      return response.on('data', function(chunk) {
        var accessToken, fileName, i, options, pageNum, params, pfopReq, reqBody, saveKey, saveasStr, signingStr, _i, _results;
        pageNum = JSON.parse(chunk).page_num;
        console.log('Page num is ' + JSON.parse(chunk).page_num);
        fileName = pdfKey.replace(/\.pdf$/i, '');
        if (slideProcessStatus[fileName] == null) {
          console.error("Cannot find " + fileName + " entry in slideProcessStatus");
          return res.json(500);
        }
        slideProcessStatus[fileName].imgKeys = [];
        slideProcessStatus[fileName].total = pageNum;
        slideProcessStatus[fileName].counter = 0;
        _results = [];
        for (i = _i = 1; 1 <= pageNum ? _i <= pageNum : _i >= pageNum; i = 1 <= pageNum ? ++_i : --_i) {
          saveKey = fileName + '-slide-' + i + '.jpg';
          saveasStr = makeSaveasStr(saveKey);
          params = {
            bucket: saveBucket,
            key: pdfKey,
            fops: 'odconv/jpg/page/' + i + '/density/' + density + '/quality/' + quality + '/resize/' + resize + saveasStr,
            pipeline: 'testppt',
            notifyURL: "http://" + nodejsServer + "/api/qiniu/pfop_notify/pdf2img"
          };
          reqBody = querystring.stringify(params);
          signingStr = "/pfop/\n" + reqBody;
          accessToken = makeAccessToken(signingStr);
          options = {
            hostname: 'api.qiniu.com',
            path: '/pfop/',
            method: 'POST',
            headers: {
              Host: 'api.qiniu.com',
              'Content-Type': 'application/x-www-form-urlencoded',
              Authorization: accessToken
            }
          };
          pfopReq = http.request(options, function(response) {
            console.log('STATUS:' + response.statusCode);
            if (response.statusCode !== 200) {
              console.error("Qiniu failed to process PPT file");
              return res.json(response.statusCode);
            }
          });
          console.log('Sending pdf2image processing request, page num ' + i);
          pfopReq.write(reqBody, 'utf8');
          pfopReq.end();
          _results.push(pfopReq.on('error', function(e) {
            console.log('Failed to process ppt ' + e);
            return res.json(500, e);
          }));
        }
        return _results;
      });
    });
  };


  /*
    Use qiniu cloud service to process PPT file and
    return list resource keys of generated static images
   */

  exports.process = function(req, res) {
    var accessToken, fileName, options, params, pdfKey, pfopReq, pptKey, reqBody, saveasStr, signingStr;
    pptKey = req.params.key;
    console.log('PPT key is ' + pptKey);
    pdfKey = pptKey.replace(/(ppt|pptx)$/i, 'pdf');
    fileName = pptKey.replace(/\.(ppt|pptx)$/i, '');
    console.log('PDF key is ' + pdfKey);
    saveasStr = makeSaveasStr(pdfKey);
    params = {
      bucket: saveBucket,
      key: pptKey,
      fops: 'odconv/pdf' + saveasStr,
      pipeline: 'testppt',
      notifyURL: "http://" + nodejsServer + "/api/qiniu/pfop_notify/ppt2pdf"
    };
    reqBody = querystring.stringify(params);
    console.log('ReqBody is ' + reqBody);
    signingStr = "/pfop/\n" + reqBody;
    accessToken = makeAccessToken(signingStr);
    options = {
      hostname: 'api.qiniu.com',
      path: '/pfop/',
      method: 'POST',
      headers: {
        Host: 'api.qiniu.com',
        'Content-Type': 'application/x-www-form-urlencoded',
        Authorization: accessToken
      }
    };
    pfopReq = http.request(options, function(response) {
      console.log('STATUS:' + response.statusCode);
      if (response.statusCode !== 200) {
        console.error("Qiniu failed to process PPT file");
        return res.json(response.statusCode);
      } else {
        slideProcessStatus[fileName] = {};
        return slideProcessStatus[fileName].response = res;
      }
    });
    pfopReq.write(reqBody, 'utf8');
    pfopReq.end();
    return pfopReq.on('error', function(e) {
      console.log('Failed to process ppt ' + e);
      return res.json(500, e);
    });
  };

  mediaEvents.mediaProcess.on('ppt2pdf', function(key) {
    var fileName, response;
    fileName = key.replace(/\.pdf$/i, '');
    response = slideProcessStatus[fileName].response;
    return cvtPdf2Img(key, response);
  });

  mediaEvents.mediaProcess.on('pdf2img', function(key) {
    var entry, fileName;
    console.log('Received pdf2img event, image key is ' + key);
    fileName = key.replace(/-slide-[0-9]+\.jpg$/i, '');
    entry = slideProcessStatus[fileName];
    if (entry == null) {
      console.error("Cannot find entry for filename " + fileName);
      return;
    }
    entry.counter++;
    entry.imgKeys.push(key);
    if (entry.counter === entry.total) {
      entry.response.json(200, entry.imgKeys);
      return delete slideProcessStatus[fileName];
    }
  });

}).call(this);

//# sourceMappingURL=slide.controller.js.map

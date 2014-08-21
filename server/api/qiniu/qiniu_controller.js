(function() {
  var bucketName, cache, config, domain, fs, http, mediaEvents, path, qiniu, randomstring, signedUrlExpires, tempDir;

  qiniu = require('qiniu');

  config = require('../../config/environment');

  randomstring = require('randomstring');

  cache = require('memory-cache');

  path = require('path');

  fs = require('fs');

  http = require('http');

  mediaEvents = require('../../common/media_process_event');

  qiniu.conf.ACCESS_KEY = config.qiniu.access_key;

  qiniu.conf.SECRET_KEY = config.qiniu.secret_key;

  domain = config.qiniu.domain;

  bucketName = config.qiniu.bucket_name;

  signedUrlExpires = config.qiniu.signed_url_expires;

  tempDir = config.local.tempDir;


  /*
    return qiniu upload token
   */

  exports.uptoken = function(req, res) {
    var putPolicy, randomDirName, token;
    putPolicy = new qiniu.rs.PutPolicy(bucketName);
    token = putPolicy.token();
    randomDirName = randomstring.generate(10);
    return res.json(200, {
      random: randomDirName,
      token: token
    });
  };


  /*
    return qiniu signed URL for download from private bucket
   */

  exports.signedUrl = function(req, res) {
    var baseUrl, cached, downloadUrl, key, policy;
    key = req.params.key;
    cached = cache.get(key);
    if (cached) {
      return res.send(200, cached);
    }
    baseUrl = qiniu.rs.makeBaseUrl(domain, key);
    policy = new qiniu.rs.GetPolicy(signedUrlExpires);
    downloadUrl = policy.makeRequest(decodeURIComponent(baseUrl));
    cache.put(key, downloadUrl, (signedUrlExpires - 60 * 60) * 1000);
    return res.send(200, downloadUrl);
  };

  exports.receiveNotify = function(req, res) {
    var result, type;
    type = req.params.type;
    console.log("notify type is " + type);
    result = req.body;
    res.send(200);
    if (result.code !== 0) {
      console.error("Qiniu media process " + type + " failed");
      return;
    }
    switch (type) {
      case 'ppt2pdf':
        return mediaEvents.mediaProcess.emit('ppt2pdf', result.items[0].key);
      case 'pdf2img':
        return mediaEvents.mediaProcess.emit('pdf2img', result.items[0].key);
      default:
        return console.error("Unknown process type");
    }
  };

  exports.uploadFile = function(req, res) {
    var extra, fileName, key, localFile, putPolicy, randomDirName, upToken;
    localFile = req.body.localFile;
    fileName = path.basename(localFile);
    randomDirName = randomstring.generate(10);
    key = randomDirName + '/' + fileName;
    putPolicy = new qiniu.rs.PutPolicy(bucketName);
    upToken = putPolicy.token();
    extra = new qiniu.io.PutExtra();
    return qiniu.io.putFile(upToken, key, localFile, extra, function(err, ret) {
      if (err) {
        console.error(err);
        return res.send(500);
      } else {
        console.log(ret.key + ':' + ret.hash);
        return res.send(200);
      }
    });
  };

  exports.downloadFile = function(req, res) {
    var baseUrl, downloadUrl, file, key, policy;
    key = req.params.key;
    console.log('Resource key is ' + key);
    baseUrl = qiniu.rs.makeBaseUrl(domain, key);
    policy = new qiniu.rs.GetPolicy();
    downloadUrl = policy.makeRequest(baseUrl);
    file = fs.createWriteStream(tempDir + '/' + encodeURIComponent(key));
    return http.get(downloadUrl, function(response) {
      response.pipe(file);
      return res.send(200);
    });
  };

}).call(this);

//# sourceMappingURL=qiniu_controller.js.map

(function() {
  var fs, http;

  http = require('http');

  fs = require('fs');

  exports.downloadFile = function(url, dest, cb) {
    var file, request;
    file = fs.createWriteStream(dest);
    return request = http.get(url, function(res) {
      res.pipe(file);
      return file.on('finish', function() {
        return file.close(cb);
      });
    }).on('error', function(err) {
      console.error('There is an error while downloading file from ' + url);
      return fs.unlink(dest);
    });
  };

}).call(this);

//# sourceMappingURL=helpers.js.map

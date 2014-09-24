(function() {
  var fs, http, xlsx, _;

  http = require('http');

  fs = require('fs');

  xlsx = require('node-xlsx');

  _ = require('lodash');

  exports.processFile = function(url, dest, cb) {
    var file, request;
    file = fs.createWriteStream(dest);
    return request = http.get(url, function(res) {
      res.pipe(file);
      return file.on('finish', function() {
        return file.close(function() {
          var data, obj, userList;
          console.log('Start parsing file...');
          obj = xlsx.parse(dest);
          data = obj.worksheets[0].data;
          console.log('data is ...');
          console.log(data);
          if (!data) {
            console.error('Failed to parse user list file or empty file');
          }
          return userList = _.rest(data);
        });
      });
    }).on('error', function(err) {
      console.error('There is an error while downloading file from ' + url);
      return fs.unlink(dest);
    });
  };

}).call(this);

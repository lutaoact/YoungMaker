(function() {
  'use strict';
  module.exports = {
    mongo: {
      uri: 'mongodb://localhost/budweiser-dev'
    },
    qiniu: {
      access_key: '_NXt69baB3oKUcLaHfgV5Li-W_LQ-lhJPhavHIc_',
      secret_key: 'qpIv4pTwAQzpZk6y5iAq14Png4fmpYAMsdevIzlv',
      domain: 'temp-cloud3edu-com.qiniudn.com',
      bucket_name: 'temp-cloud3edu-com',
      signed_url_expires: 24 * 60 * 60
    },
    logger: {
      path: '/data/log/budweiser.log',
      level: 'DEBUG'
    },
    local: {
      tempDir: '/temp_node_dir'
    },
    nodejsServer: '115.29.244.232'
  };

}).call(this);

//# sourceMappingURL=development.js.map

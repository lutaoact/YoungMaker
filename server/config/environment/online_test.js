(function() {
  'use strict';
  module.exports = {
    mongo: {
      uri: 'mongodb://localhost/budweiser'
    },
    qiniu: {
      access_key: '_NXt69baB3oKUcLaHfgV5Li-W_LQ-lhJPhavHIc_',
      secret_key: 'qpIv4pTwAQzpZk6y5iAq14Png4fmpYAMsdevIzlv',
      domain: 'temp-cloud3edu-com.qiniudn.com',
      bucket_name: 'temp-cloud3edu-com',
      signed_url_expires: 24 * 60 * 60
    },
    aws: {
      accessKeyId: 'AKIAOQO4QDXGFY3APFBQ',
      secretAccessKey: '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',
      region: 'cn-north-1',
      slideBucket: 'slides.cloud3edu.cn',
      slideUploadBucket: 'temp.cloud3edu.cn',
      algorithm: 'AWS4-HMAC-SHA256'
    },
    azure: {
      accountName: 'trymedia',
      accountKey: 'HQVc3/yjrl8QDw7/NKvnbG2/jFmN7mJ++75xunlVD+M=',
      acsBaseAddress: "https://wamsprodglobal001acs.accesscontrol.chinacloudapi.cn/v2/OAuth2-13",
      bjbAPIServerAddress: 'https://wamsshaclus001rest-hs.chinacloudapp.cn/API/',
      shaAPIServerAddress: 'https://wamsbjbclus001rest-hs.chinacloudapp.cn/API/',
      signed_url_expires: 24 * 60,
      defaultHeaders: function(access_token) {
        return {
          Accept: 'application/json;odata=verbose',
          DataServiceVersion: '3.0',
          MaxDataServiceVersion: '3.0',
          'x-ms-version': '2.5',
          'Content-Type': 'application/json;odata=verbose',
          Authorization: 'Bearer ' + access_token
        };
      }
    },
    logger: {
      path: '/data/log/budweiser.log',
      level: 'DEBUG'
    },
    local: {
      tempDir: '/temp_node_dir'
    },
    nodejsServer: '115.29.244.232',
    assetHost: {
      images: 'qiniu',
      slides: 's3',
      videos: 'azure',
      uploadImage: 'qiniu',
      uploadSlide: 's3',
      uploadVideo: 'azure'
    },
    redis: {
      port: 6379,
      host: "localhost"
    }
  };

}).call(this);

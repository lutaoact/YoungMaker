(function() {
  var config, getQPromisedOps, redis, redisClient, redisHost, redisPort;

  redis = require('redis');

  config = require('../config/environment');

  redisPort = config.redis.port;

  redisHost = config.redis.host;

  redisClient = redis.createClient(redisPort, redisHost);

  getQPromisedOps = function(client) {
    var functions, lc, op, ops, q, _i, _len;
    functions = _.functions(client);
    ops = functions.filter(function(f) {
      return f.toUpperCase() === f;
    });
    lc = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = ops.length; _i < _len; _i++) {
        op = ops[_i];
        _results.push(op.toLowerCase());
      }
      return _results;
    })();
    ops = ops.concat(lc);
    q = {};
    for (_i = 0, _len = ops.length; _i < _len; _i++) {
      op = ops[_i];
      q[op] = Q.nbind(client[op], client);
    }
    q["multi"] = q["MULTI"] = function() {
      var m;
      m = client.multi.apply(client, arguments);
      m.exec = Q.nbind(m.exec, m);
      return m;
    };
    return q;
  };

  redisClient.q = getQPromisedOps(redisClient);

  module.exports = redisClient;

}).call(this);

//# sourceMappingURL=redisClient.js.map

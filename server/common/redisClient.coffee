redis         = require 'redis'
redisPort     = config.redis.port
redisHost     = config.redis.host
redisClient   = redis.createClient redisPort, redisHost

  # Add promised version of ops of Redis
getQPromisedOps = (client) ->
    functions = _.functions client

    # a hack to find out ops funtions in client
    ops = functions.filter (f) -> f.toUpperCase() is f
    lc = (op.toLowerCase() for op in ops)
    ops = ops.concat lc
    q = {}
    for op in ops
      q[op] = Q.nbind client[op], client

    # also bind exec returned from executing multi
    q["multi"] = q["MULTI"] = ->
      m = client.multi.apply client, arguments
      m.exec = Q.nbind m.exec, m
      m
    q

redisClient.q = getQPromisedOps redisClient

module.exports = redisClient

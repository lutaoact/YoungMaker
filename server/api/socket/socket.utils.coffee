BaseUtils = require('../../common/BaseUtils').BaseUtils
jwt = require('jsonwebtoken')

exports.SocketUtils = BaseUtils.subclass
  classname: 'SocketUtils'

  verify: (token, cb) ->
    deferred = do Q.defer
    jwt.verify token, config.secrets.session, null, (err, user) ->
      if err then deferred.reject err else deferred.resolve user

    return deferred.promise.nodeify cb

  $buildErrMsg: (err) ->
    util = require 'util'
    type: 'error'
    payload:
      status: 401
      errMsg: util.inspect err

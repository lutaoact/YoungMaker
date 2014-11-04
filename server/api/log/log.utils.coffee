'use strict'

BaseUtils = require '../../common/BaseUtils'

class LogUtils extends BaseUtils
  write: (type, data) ->
    loggerD.write [type, JSON.stringify data].join "\t"

exports.Instance = new LogUtils()
exports.Class = LogUtils

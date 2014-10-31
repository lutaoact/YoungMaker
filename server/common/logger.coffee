log4js = require 'log4js'
path = require 'path'
stackTrace = require 'stack-trace'

getCallerFile = ->
  frame = stackTrace.get()[8]
  file  = path.relative process.cwd(), frame.getFileName()
  dir   = path.dirname file
  ext   = path.extname file
  base  = path.basename file, ext
  line  = frame.getLineNumber()
  "#{dir}/#{base}#{ext}##{line}"

log4js.configure
  appenders: [
    type        : 'console'
    layout      :
      type      : 'pattern'
      pattern   : "%d{ISO8601} %x{filename} %[%-5p%] - %c %m"
      tokens    :
        filename: getCallerFile
  ,
    type        : 'file'
    filename    : config.logger.path
    layout      :
      type      : 'pattern'
      pattern   : "%d{ISO8601} %x{filename} %-5p - %c %m"
      tokens    :
        filename: getCallerFile
    category    : '[BUDWEISER]'
  ]

logger = log4js.getLogger '[BUDWEISER]'
logger.setLevel config.logger.level

exports.logger = logger

require './initGlobal'

#不在继续使用modelMap全局对象，如果需要使用，取消注释以下代码
#makeModelMap = (cb) ->
#  FileUtils = require 'fileutils'
#  map = {}
#  FileUtils.eachFileMatching /\.model\.js$/, __dirname + '/../api'
#  , (err, file, stat) ->
#    modelName = file.replace /^.*\/(\w+)\.model.js$/, "$1"
#    map[modelName] = new (require(file)[_u.convertToCamelCase(modelName)])
#  , (err, files, stats) ->
#    global.modelMap = map
#    do cb
#
#module.exports = makeModelMap
#
#makeModelMap () ->
#  console.log 'model load finished'

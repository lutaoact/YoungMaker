require '../server/common/init'

xlsx = require 'node-xlsx'
fs = require 'fs'
obj =  xlsx.parse './xqsh.xls'
datas = obj.worksheets[0].data[2..]
#datas = require './testData.coffee'
#console.log datas

result = {}
for line in datas
  values = _.pluck line, 'value'
  result[values[2]] ?= {}
  result[values[2]][values[3]] = values[4]

console.log result
fs.writeFile 'xqsh.json', JSON.stringify(result, null, 4), (err) ->
  if err then console.log err

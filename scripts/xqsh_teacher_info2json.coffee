'use strict'
require '../server/common/init'

fs = require 'fs'
outfile = "#{__dirname}/xqsh_teacher_info.json"
result = {}
fs.readFile "#{__dirname}/xqsh_teacher_info.csv", {encoding: 'utf-8'}, (err, data) ->
  lines = (data.split "\n")[1..-2]
  for line in lines
    info = line.split ','
    result[info[0]] = info[1]

  console.log result

  fs.writeFile outfile, JSON.stringify(result, null, 4), (err) ->
    if err then console.log err

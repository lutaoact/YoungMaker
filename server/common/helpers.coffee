http = require 'http'
fs = require 'fs'

exports.downloadFile = (url, dest, cb) ->
  file = fs.createWriteStream dest
  request = http.get url, (res) ->
    res.pipe file
    file.on 'finish', () ->
      file.close cb
  .on 'error' , (err) ->
    console.error 'There is an error while downloading file from ' + url
    fs.unlink dest  # delete the file async

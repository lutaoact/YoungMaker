http = require 'http'
fs = require 'fs'
xlsx = require 'node-xlsx'
_ = require 'lodash'

exports.processFile = (url, dest, cb) ->
  file = fs.createWriteStream dest
  request = http.get url, (res) ->
    res.pipe file
    file.on 'finish', () ->
      file.close () ->
        console.log 'Start parsing file...'
        obj = xlsx.parse dest

        data = obj.worksheets[0].data

        console.log 'data is ...'
        console.log data

        if not data
          console.error 'Failed to parse user list file or empty file'

        # real user data starting from second row
        userList = _.rest data

  .on 'error' , (err) ->
    console.error 'There is an error while downloading file from ' + url
    fs.unlink dest  # delete the file async

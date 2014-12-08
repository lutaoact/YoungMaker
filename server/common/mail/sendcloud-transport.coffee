https = require "https"
qs = require "querystring"
url = require "url"

class SendCloudTransport
  constructor: (options) ->
    options = options or {}
    @options = options
    @name = "SendCloud"

  send: (mail, callback) ->
    email = mail.data
    email.api_key = @options.auth.api_key
    email.api_user = @options.auth.api_user
    content = qs.stringify(email)
    options =
      host: "sendcloud.sohu.com"
      port: 443
      path: "/webapi/mail.send.json"
      method: "POST"
      headers:
        "Content-Type": "application/x-www-form-urlencoded"
        "Content-Length": content.length

    req = https.request options, (res) ->
      _data = ""
      res.on "data", (chunk) ->
        console.log chunk
        _data += chunk

      res.on "end", ->
        console.log 'wtf'+_data
        callback undefined, _data

    req.on "error", (e) ->
      callback e

    req.write content
    req.end()

module.exports = (options) ->
  new SendCloudTransport(options)
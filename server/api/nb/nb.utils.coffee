BaseUtils = require '../../common/BaseUtils'

request = require('request').defaults({jar: true, followRedirect: false})

class NbUtils extends BaseUtils
  login: (email, password, cb) ->
    url = "#{config.nbUrl}/login"

    request.get(url, (err, res, body) ->
      regexp = /<input type="hidden" name="_csrf" value="(.*?)" id="csrf-token"/
      csrftoken = regexp.exec(body)[1]

      authAttributes = { _csrf: csrftoken, email: email, password: password }
      request.post(url, {body: authAttributes, json: true}, cb)
    )

  loginQ: () ->
    return Q.nfapply @login, arguments

exports.Instance = new NbUtils()
exports.Class = NbUtils

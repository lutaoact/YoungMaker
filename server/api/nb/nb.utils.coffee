BaseUtils = require '../../common/BaseUtils'

request = require('request').defaults({jar: true, followRedirect: false})

class NbUtils extends BaseUtils
  login: (email, password, cb) ->
    url = "#{config.nbUrl}/login"

    request.get(url, (err, res, body) ->
      regexp = /<input type="hidden" name="_csrf" value="(.*?)" id="csrf-token"/
      csrftoken = regexp.exec(body)[1]
#      console.log csrftoken

      authAttributes = { _csrf: csrftoken, email: email, password: password }
      request.post(url, {body: authAttributes, json: true}, cb)
    )

  loginQ: (email, password) ->
    return Q.nfapply @login, arguments

  register: (email, password, cb) ->
    url = "#{config.nbUrl}/register"
    request.get(url, (err, res, body) ->
#      console.log body
#      <input type="hidden" name="_csrf" value="D9IFTOX7-e-31jEMD" />
      regexp = /<input type="hidden" name="_csrf" value="(.*?)" .>/
      csrftoken = regexp.exec(body)[1]
#      console.log csrftoken
      postBody =
        _csrf: csrftoken
        email: email
        username: email
        password: password
        'password-confirm': password

      request.post(url, {body: postBody, json: true}, cb)
    )

  registerQ: (email, password) ->
    return Q.nfapply @register, arguments


exports.Instance = new NbUtils()
exports.Class = NbUtils
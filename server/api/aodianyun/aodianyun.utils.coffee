BaseUtils = require('../../common/BaseUtils')

APPID     = '838914989936'
APPSECRET = '3sy9I2jw3qmjqAudaQM1HrSBhbL3mCez'

request = require 'request'

getAppUrl     = 'http://openapi.aodianyun.com/v2/LSS.GetApp'
openAppUrl    = 'http://openapi.aodianyun.com/v2/LSS.OpenApp'
closeAppUrl   = 'http://openapi.aodianyun.com/v2/LSS.CloseApp'
restartAppUrl = 'http://openapi.aodianyun.com/v2/LSS.RestartApp'

class AodianyunUtils extends BaseUtils
  openThenStart: (classeId) ->
    @getAppQ()
    .then (appids) =>
      if _u.contains appids, classeId
        @restartAppQ classeId
      else
        @openAppQ classeId

  getApp: (cb) ->
    parameter = JSON.stringify({access_id: APPID, access_key: APPSECRET})
    #json: true这个参数会将相应的body自动解析
    request.post getAppUrl, {form: {parameter: parameter}, json: true}, (err, res, body) ->
      if err then return cb err
      unless body.Flag is 100 then return cb body.FlagString #body.Flag不为100，则表示出错

      cb null, _.pluck body.List, 'appid'

  getAppQ: () ->
    return Q.nfapply (Q.nbind @getApp, @), arguments

  openApp: (classeId, cb) ->
    parameter = JSON.stringify(
      access_id: APPID
      access_key: APPSECRET
      appid: classeId
      appname: classeId
    )
    #json: true这个参数会将相应的body自动解析
    request.post openAppUrl, {form: {parameter: parameter}, json: true}, (err, res, body) ->
      if err then return cb err
      unless body.Flag is 100 then return cb body.FlagString #body.Flag不为100，则表示出错

      cb()

  openAppQ: () ->
    return Q.nfapply (Q.nbind @openApp, @), arguments

  closeApp: (classeId, cb) ->
    parameter = JSON.stringify(
      access_id: APPID
      access_key: APPSECRET
      appid: classeId
    )
    #json: true这个参数会将相应的body自动解析
    request.post closeAppUrl, {form: {parameter: parameter}, json: true}, (err, res, body) ->
      if err then return cb err
      unless body.Flag is 100 then return cb body.FlagString #body.Flag不为100，则表示出错

      cb()

  closeAppQ: () ->
    return Q.nfapply (Q.nbind @closeApp, @), arguments

  restartApp: (classeId, cb) ->
    parameter = JSON.stringify(
      access_id: APPID
      access_key: APPSECRET
      appid: classeId
    )
    #json: true这个参数会将相应的body自动解析
    request.post restartAppUrl, {form: {parameter: parameter}, json: true}, (err, res, body) ->
      if err then return cb err
      unless body.Flag is 100 then return cb body.FlagString #body.Flag不为100，则表示出错

      cb()

  restartAppQ: () ->
    return Q.nfapply (Q.nbind @restartApp, @), arguments

exports.Class = AodianyunUtils
exports.Instance = new AodianyunUtils()

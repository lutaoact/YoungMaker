require '../common/init'
passport = require 'passport'

User = _u.getModel 'user'
WeiboStrategy = require('passport-weibo').Strategy
QQStrategy = require('passport-qq').Strategy
WeixinStrategy = require('passport-weixin-plus').Strategy

#passport.use(new WeiboStrategy({
#  clientID    : config.weiboAuth.appkey
#  clientSecret: config.weiboAuth.secret
#  callbackURL : config.weiboAuth.oauth_callback_url
#  passReqToCallback: true
#}, (req, token, refreshToken, profile, done) ->
#  logger.info "Weibo profile"
#  logger.info profile
#  if req.user?
#    user = req.user
#
#    user.weibo.id    = profile.id
#    user.weibo.token = token
#    user.weibo.name  = profile.displayName
#
#    user.save (err) ->
#      if err then return done err
#
#      done null, user
#  else
#    User.findOne {'weibo.id': profile.id}, (err, user) ->
#      if err then return done err
#
#      #如果用户未绑定，则将授权信息传给前端，完成绑定
#      unless user
#        payload =
#          weibo_id   : profile.id
#          weibo_token: token
#          weibo_name : profile.displayName
#        return done null, false, payload
#
#      user.weibo.token = token
#      user.weibo.name  = profile.displayName
#
#      user.save (err) ->
#        if err then return done err
#
#        done null, user
#))
#
#passport.use(new QQStrategy({
#  clientID    : config.qqAuth.appkey
#  clientSecret: config.qqAuth.secret
#  callbackURL : config.qqAuth.oauth_callback_url
#  passReqToCallback: true
#}, (req, token, refreshToken, profile, done) ->
#  logger.info "QQ profile"
#  logger.info profile
#  if req.user?
#    user = req.user
#
#    user.qq.id    = profile.id
#    user.qq.token = token
#    user.qq.name  = profile.nickname
#
#    user.save (err) ->
#      if err then return done err
#
#      done null, user
#  else
#    User.findOne {'qq.id': profile.id}, (err, user) ->
#      if err then return done err
#
#      #如果用户未绑定，则将授权信息传给前端，完成绑定
#      unless user
#        payload =
#          qq_id   : profile.id
#          qq_token: token
#          qq_name : profile.nickname
#        return done null, false, payload
#
#      user.qq.token = token
#      user.qq.name  = profile.nickname
#
#      user.save (err) ->
#        if err then return done err
#
#        done null, user
#))

passport.use(new WeixinStrategy({
  clientID    : config.weixinAuth.appkey
  clientSecret: config.weixinAuth.secret
  callbackURL : config.weixinAuth.oauth_callback_url
  requireState: false
  scope       : 'snsapi_login'
  passReqToCallback: true
}, (req, token, refreshToken, profile, done) ->
  weixin =
    id   : profile.id
    token: token
    name : profile.displayName
    other: profile

  User.findOne {'weixin.id': profile.id}, (err, dbUser) ->
    if err then return done err

    if dbUser
      dbUser.weixin = weixin

      dbUser.save (err) ->
        return done err, dbUser
    else
      if req.user
        req.user.weixin = weixin
        req.user.save (err) ->
          return done err, req.user
      else
        data =
          name: weixin.name
          avatar: profile.profileUrl
          weixin: weixin
        User.create data, (err, user) ->
          return done err, user
))

passport.use('weixin_userinfo', new WeixinStrategy({
  authorizationURL: 'https://open.weixin.qq.com/connect/oauth2/authorize'
  clientID    : (req) ->
    return global.weixinAuth[req.headers.host].gongappid
  clientSecret: (req) ->
    return global.weixinAuth[req.headers.host].gongsecret
  callbackURL : (req) ->
    return "http://#{req.headers.host}/auth/weixin_userinfo/callback"
  requireState: false
  scope       : 'snsapi_userinfo'
  passReqToCallback: true
}, (req, token, refreshToken, profile, done) ->
  logger.info profile
  weixin =
    id   : profile.id
    token: token
    name : profile.displayName
    other: profile

  User.findOne {'weixin.id': profile.id, orgId: req.org?._id}, (err, dbUser) ->
    if err then return done err
    if dbUser
      dbUser.weixin = weixin

      dbUser.save (err) ->
        return done err, dbUser
    else
      done()
))

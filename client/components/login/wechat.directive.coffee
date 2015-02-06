angular.module 'maui.components'

.directive 'weixinLogin' , ($location) ->
  restrict : 'E'
  replace: true
  template : """<div id="weixin-login"></div>"""
  link : ->
    redirect = $location.absUrl()
    baseUrl  = $location.protocol() + "://" + $location.host()
    new WxLogin
      id    : 'weixin-login'
      appid : 'wx0b867034fb0d7f4e'
      scope : 'snsapi_login'
      state : 'STATE'
      style : 'black'
      redirect_uri: baseUrl + '/auth/weixin/callback?redirect='+redirect

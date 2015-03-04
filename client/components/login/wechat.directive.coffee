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
      appid : 'wxda486048345cc138'
      scope : 'snsapi_login'
      state : 'STATE'
      style : 'black'
      redirect_uri: baseUrl + '/auth/weixin/callback?redirect='+redirect

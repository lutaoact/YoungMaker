'use strict'

# 封装主App，用 ngMockE2E 模拟其中的服务器请求
angular.module 'budweiserAppDev', [
  'budweiserApp'
  'ngMockE2E'
]

# 延迟 $httpbackend 返回结果，模拟服务器请求延时行为
.config ($provide) ->
  $provide.decorator '$httpBackend', ($delegate) ->
    proxy = (method, url, data, callback, headers) ->
      interceptor = ->
        _this = this
        _arguments = arguments
        setTimeout( ->
          callback.apply(_this, _arguments)
        , 800)
      $delegate.call(this, method, url, data, interceptor, headers)
    for key of $delegate
      proxy[key] = $delegate[key]
    proxy

.run (
  $httpBackend
) ->

  console.debug "Start Mock HttpBackend ..."

  $httpBackend.whenGET(/.*/).passThrough()
  $httpBackend.whenPUT(/.*/).passThrough()
  $httpBackend.whenPOST(/.*/).passThrough()
  $httpBackend.whenDELETE(/.*/).passThrough()
  $httpBackend.whenJSONP(/.*/).passThrough()
  $httpBackend.whenPATCH(/.*/).passThrough()

'use strict'

# 封装主App，用 ngMockE2E 模拟其中的服务器请求
angular.module 'mauiAppDev', [
  'mauiApp'
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
      # url = decodeURIComponent(url?.replace(/\+/g, '%20'))
      $delegate.call(this, method, url, data, interceptor, headers)
    for key of $delegate
      proxy[key] = $delegate[key]
    proxy

.run (
  $httpBackend
) ->


  $httpBackend.whenGET(/^api\/courses$/)
  .respond (method, url, data)->
    console.log 'Mock get courses'
    [200, 'get courses']

  $httpBackend.whenGET(/^api\/courses\/[0-9]+$/)
  .respond (method, url, data)->
    console.log 'Mock get course by id'
    [200, 'get course by id']

  $httpBackend.whenGET(/^api\/lectures\?courseId=/)
  .respond (method, url, data)->
    console.log 'get lectures by courseId'
    [200, 'get lectures by courseId']

  $httpBackend.whenGET(/^api\/lectures\/[0-9]+$/)
  .respond (method, url, data)->
    console.log 'get lecture by id'
    [200, 'get lecture by id']

  console.log "Start Mock HttpBackend ..."

  $httpBackend.whenGET(/.*/).passThrough()
  $httpBackend.whenPUT(/.*/).passThrough()
  $httpBackend.whenPOST(/.*/).passThrough()
  $httpBackend.whenDELETE(/.*/).passThrough()
  $httpBackend.whenJSONP(/.*/).passThrough()
  $httpBackend.whenPATCH(/.*/).passThrough()

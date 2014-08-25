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
      # url = decodeURIComponent(url?.replace(/\+/g, '%20'))
      $delegate.call(this, method, url, data, interceptor, headers)
    for key of $delegate
      proxy[key] = $delegate[key]
    proxy

.run (
  $httpBackend, Auth
) ->

  $httpBackend.whenGET(/^api\/courses$/).respond (method, url, data)->
    if Auth.getCurrentUser().role is 'student'
      courses = [
        {
          _id: 1
          name: '数学'
        }
        {
          _id: 2
          name: '语文'
        }
      ]
    else if Auth.getCurrentUser().role is 'teacher'
      courses = [
        {
          _id: 1
          name: '数学'
        }
        {
          _id: 2
          name: '语文'
        }
        {
          _id: 3
          name: '物理'
        }
        {
          _id: 4
          name: '化学'
        }
      ]
    else
      courses = [
        {
          _id: 1
          name: '数学'
        }
        {
          _id: 2
          name: '语文'
        }
        {
          _id: 3
          name: '物理'
        }
        {
          _id: 4
          name: '化学'
        }
      ]
    [200, courses]

  $httpBackend.whenGET(/^api\/courses\/(1|2|3|4)$/).respond (method, url, data)->
    console.log 'get course by id'
    course = {
      _id: 1
      name: '数学'
    }
    [200, course]

  console.debug "Start Mock HttpBackend ..."

  $httpBackend.whenGET(/.*/).passThrough()
  $httpBackend.whenPUT(/.*/).passThrough()
  $httpBackend.whenPOST(/.*/).passThrough()
  $httpBackend.whenDELETE(/.*/).passThrough()
  $httpBackend.whenJSONP(/.*/).passThrough()
  $httpBackend.whenPATCH(/.*/).passThrough()

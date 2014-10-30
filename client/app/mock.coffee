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
  $httpBackend, Auth
) ->

  courses = _.map ['语文','数学','物理','化学','生物','地理','政治','历史']
  , (item, index)->
    _id: index
    name: item
    category: item
    info: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.
    Recusandae, error molestiae reprehenderit soluta qui cupiditate
    incidunt accusamus cumque aspernatur, architecto praesentium consequuntur,
    sed consectetur totam aliquid. Harum quo dolorum, nam.
    '.substr(0,Math.floor(Math.random() * 100) + 100)
    thumbnail: "http://lorempixel.com/480/480/?r=#{index}"

  lectures = _.map [1..30], (item)->
    _id: item
    name: '第' + item + '课'
    info: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.
    Recusandae, error molestiae reprehenderit soluta qui cupiditate incidunt
    accusamus cumque aspernatur, architecto praesentium consequuntur,
    sed consectetur totam aliquid. Harum quo dolorum, nam.
    '.substr(0,Math.floor(Math.random() * 100) + 100)
    slides: _.map [1..10], (item)->
      thumb: "http://lorempixel.com/480/360/?r=#{item}"


  $httpBackend.whenGET(/^api\/courses$/).respond (method, url, data)->
    console.debug 'Mock get courses'
    if Auth.getCurrentUser().role is 'student'
      [200, courses.slice(0,3)]
    else if Auth.getCurrentUser().role is 'teacher'
      [200, courses.slice(3,3)]
    else
      [200, courses]

  $httpBackend.whenGET(/^api\/courses\/[0-9]+$/)
  .respond (method, url, data)->
    console.debug 'Mock get course by id'
    [200, courses[0]]

  $httpBackend.whenGET(/^api\/lectures\?courseId=/)
  .respond (method, url, data)->
    console.debug 'get lectures by courseId'
    [200, lectures]

  $httpBackend.whenGET(/^api\/lectures\/[0-9]+$/)
  .respond (method, url, data)->
    console.debug 'get lecture by id'
    [200, lectures[0]]

  console.debug "Start Mock HttpBackend ..."

  $httpBackend.whenGET(/.*/).passThrough()
  $httpBackend.whenPUT(/.*/).passThrough()
  $httpBackend.whenPOST(/.*/).passThrough()
  $httpBackend.whenDELETE(/.*/).passThrough()
  $httpBackend.whenJSONP(/.*/).passThrough()
  $httpBackend.whenPATCH(/.*/).passThrough()

'use strict'

angular.module('mauiApp').filter 'genColor', ->
  (str) ->
    str = utf8.encode str
    r = 256 - str.substr(-1,1).charCodeAt()
    g = 256 - str.substr(-4,1).charCodeAt()
    b = 256 - str.substr(-7,1).charCodeAt()
    'rgb(' + [r,g,b].join() + ')'

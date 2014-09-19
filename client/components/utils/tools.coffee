'use strict'

angular.module('budweiserApp').service '$tools', () ->
  # convert times('00:30' || '01:30' || '01:01:30' ...) to seconds (30, 90 ...)
  timeStrings2Seconds: (string) ->
    TIME_RE = /^(([0-2][0-4]):)?([0-5][0-9]):([0-5][0-9])$/g
    if times = TIME_RE.exec(string)
      _.reduceRight times, (total, time, index) ->
        if /^\d+$/g.test(time)
          i = times.length - index - 1
          total += time * Math.pow(60, i)
        total
      , 0
    else
      undefined

  #convert a string to color. Same string will return the same color
  genColor: (str)->
    str = utf8.encode str
    r = 256 - str.substr(-1,1).charCodeAt()
    g = 256 - str.substr(-4,1).charCodeAt()
    b = 256 - str.substr(-7,1).charCodeAt()
    'rgb(' + [r,g,b].join() + ')'


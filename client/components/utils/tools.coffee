'use strict'

angular.module('budweiserApp').service '$tools', () ->
  # convert times('00:30' || '01:30' || '1:01:30' ...) to seconds (30, 90 ...)
  timeStrings2Seconds: (string) ->
    times = string.split(':')
    _.reduceRight times, (total, time, index) ->
      if /^\d+$/g.test(time)
        i = times.length - index - 1
        total += time * Math.pow(60, i)
      total
    , 0

  seconds2TimeStrings: (number) ->
    sec = parseInt(number, 10)
    hours = Math.floor(sec / 3600)
    minutes = Math.floor((sec - (hours * 3600)) / 60)
    seconds = sec - (hours * 3600) - (minutes * 60)
    if (hours   < 10) then hours   = '0' + hours
    if (minutes < 10) then minutes = '0' + minutes
    if (seconds < 10) then seconds = '0' + seconds
    (if hours > 0 then hours + ':' else  '') + minutes + ':' + seconds

  #convert a string to color. Same string will return the same color
  genColor: (str)->
    str = utf8.encode str
    r = 256 - str.substr(-1,1).charCodeAt()
    g = 256 - str.substr(-4,1).charCodeAt()
    b = 256 - str.substr(-7,1).charCodeAt()
    'rgb(' + [r,g,b].join() + ')'


'use strict'

angular.module('maui.components')

.filter 'second2ReadableTime', ->
  (inputSecond) ->
    if isNaN(inputSecond) then return '00:00'
    sec = parseInt(inputSecond, 10)
    hours = Math.floor(sec / 3600)
    minutes = Math.floor((sec - (hours * 3600)) / 60)
    seconds = sec - (hours * 3600) - (minutes * 60)
    if (hours   < 10) then hours   = '0' + hours
    if (minutes < 10) then minutes = '0' + minutes
    if (seconds < 10) then seconds = '0' + seconds
    (if hours > 0 then hours + ':' else  '') + minutes + ':' + seconds

.filter 'readableTime2Second', ->
  (string) ->
    times = string.split(':')
    _.reduceRight times, (total, time, index) ->
      if /^\d+$/g.test(time)
        i = times.length - index - 1
        total += time * Math.pow(60, i)
      total
    , 0

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


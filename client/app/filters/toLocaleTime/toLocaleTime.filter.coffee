'use strict'

angular.module('budweiserApp').filter 'uxToLocaleTime', ->
  (input) ->
    if input
      result = input
      input = parseInt(input)
      result = moment.unix(input).format('lll')
      return result

angular.module('budweiserApp').filter 'toTimeStamp', ->
  (input) ->
    if input
      result = input
      result = moment(input).valueOf()
      return result

angular.module('budweiserApp').filter 'uxToHmmss', ->
  (input) ->
    result = input
    input = parseInt(input / 1000)
    data = moment.duration(input, 'seconds')._data
    result = [data.hours, ('0' + data.minutes).substring(-1,2), ('0' + data.seconds).substring(-1, 2)].join ':'
    result

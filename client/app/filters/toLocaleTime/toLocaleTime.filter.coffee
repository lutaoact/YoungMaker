'use strict'

angular.module('budweiserApp').filter 'uxToLocaleTime', ->
  (input) ->
    if input
      result = input
      input = parseInt(input)
      result = moment.unix(input).format('lll')
      return result

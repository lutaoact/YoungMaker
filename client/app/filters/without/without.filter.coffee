'use strict'

angular.module('budweiserApp').filter 'without', ->
  (items, values, key) ->
    keyValues = _.pluck values, key
    _.filter items, (item) ->
      keyValues.indexOf(item[key]) == -1


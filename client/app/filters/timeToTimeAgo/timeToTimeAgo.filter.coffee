'use strict'

angular.module('budweiserApp').filter 'timeToTimeAgo', ->
  (input) ->
    moment(String(input)).fromNow()

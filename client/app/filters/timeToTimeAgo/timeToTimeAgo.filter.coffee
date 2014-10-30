'use strict'

angular.module('mauiApp').filter 'timeToTimeAgo', ->
  (input) ->
    moment(String(input)).fromNow()

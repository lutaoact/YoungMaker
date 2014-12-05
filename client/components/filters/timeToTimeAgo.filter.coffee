'use strict'

angular.module('maui.components')

.filter 'timeToTimeAgo', ->
  (input) ->
    moment(String(input)).fromNow()

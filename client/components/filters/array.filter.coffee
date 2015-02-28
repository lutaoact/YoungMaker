'use strict'

angular.module('maui.components')

.filter 'array', ->
  (input) ->
    if _.isArray(input)
      input
    else if input
      [input]
    else
      []


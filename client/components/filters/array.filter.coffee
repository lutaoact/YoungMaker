'use strict'

angular.module('maui.components')

.filter 'array', ->
  (input) ->
    if !input
      []
    else if input.indexOf('[') > -1
      JSON.parse(input)
    else if input.indexOf(',') > -1
      input.split(',')
    else
      [input]


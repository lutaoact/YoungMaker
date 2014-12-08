'use strict'

angular.module('maui.components')

.filter 'moment', ->
  (input, type) ->
    console.debug input, moment(String(input))
    moment(String(input))[type]?()


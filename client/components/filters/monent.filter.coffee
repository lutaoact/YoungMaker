'use strict'

angular.module('maui.components')

.filter 'moment', ->
  (input, type) ->
    moment(String(input))[type]?()

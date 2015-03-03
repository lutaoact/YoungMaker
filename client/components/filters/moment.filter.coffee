'use strict'

angular.module('maui.components')

.filter 'moment', ->
  (input, type) ->
    moment(new Date(String(input)))[type]?()

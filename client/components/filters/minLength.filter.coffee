'use strict'

angular.module('maui.components')

.filter 'minLength', ->
  (input, min) ->
    if input?.length > min then input else ''

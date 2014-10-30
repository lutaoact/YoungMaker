'use strict'

angular.module('mauiApp').filter 'minLength', ->
  (input, min) ->
    if input?.length > min then input else ''

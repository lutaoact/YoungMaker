'use strict'

angular.module('budweiserApp').filter 'minLength', ->
  (input, min) ->
    if input?.length > min then input else ''

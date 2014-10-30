'use strict'

angular.module('budweiserApp').filter 'htmlToPlaintext', ->
  (input) ->
    String(input).replace(/<[^>]+>/gm, '')


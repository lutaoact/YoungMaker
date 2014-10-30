'use strict'

angular.module('mauiApp').filter 'htmlToPlaintext', ->
  (input) ->
    String(input).replace(/<[^>]+>/gm, '')


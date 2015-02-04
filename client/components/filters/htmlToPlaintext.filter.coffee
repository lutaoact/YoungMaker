'use strict'

angular.module('maui.components')

.filter 'htmlToPlaintext', ->
  (input) ->
    String(input).replace(/<[^>]+>/gm, '')


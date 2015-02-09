'use strict'

angular.module('maui.components')

.filter 'htmlToPlaintext', ->
  (input) ->
    String(input).replace(/<[^>]+>/gm, '').replace(/&#\d+?;/g, '').replace(/&lt;/g,'<').replace(/&gt;/g,'>')


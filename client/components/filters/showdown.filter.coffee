'use strict'

angular.module('maui.components').filter 'showdown', ->
  converter = new Showdown.converter()
  (input) ->
    if input
      converter.makeHtml(String(input))
    else
      ''


'use strict'

angular.module('maui.components')

.filter 'trusted', ($sce)->
  (input, type = 'html') ->
    input = String(input)
    switch type
      when 'html'
        $sce.trustAsHtml input
      when 'url'
        $sce.trustAsResourceUrl input
      else
        throw new Error('unknown trust type')


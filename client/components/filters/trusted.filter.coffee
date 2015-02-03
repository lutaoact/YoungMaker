'use strict'

angular.module('maui.components').filter 'trusted', ($sce)->
  (input) ->
    $sce.trustAsHtml String(input)


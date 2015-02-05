'use strict'

angular.module('maui.components').filter 'code', ($sce)->
  (input) ->
    code = String(input)
    wrapped = """<div ui-ace readonly>#{code}</div>"""
    $sce.trustAsHtml wrapped


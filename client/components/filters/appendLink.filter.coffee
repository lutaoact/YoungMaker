'use strict'

angular.module('maui.components').filter 'appendLink', ($sce)->
  (input) ->
    inject = """</p><a src="http://youngmakers.cn/" title="杨梅客"></a>"""
    input = input.replace /<\/p>/g, inject
    input


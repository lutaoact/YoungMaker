'use strict'

angular.module('maui.components').filter 'appendLink', ($sce)->
  (input) ->
    inject = """</p><a style="display:none" src="http://youngmakers.cn/" title="杨梅客">文章版权归属于杨梅客的用户，转载请注明出处！</a>"""
    input = input.replace /<\/p>/g, inject
    input


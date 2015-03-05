'use strict'

angular.module('maui.components').filter 'appendLink', ($sce)->
  (input) ->
#    inject = """</p><a src="http://youngmakers.cn/" title="杨梅客"></a>"""
#    input = input.replace /<\/p>/g, inject
#    input
    inject = """<a src="http://youngmakers.cn/" title="杨梅客"></a>"""
    splitResult = input.split /(<p>.+?<\/p>)/
    if splitResult?.length
      count = 1
      for frag, index in splitResult
        if /^<p>.+?<\/p>$/.test frag
          if count % 4 is 1
            splitResult[index] += inject
            count++

    splitResult.join ''

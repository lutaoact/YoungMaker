'use strict'

angular.module 'maui.components'

.filter 'images', ->
  (htmlString) ->
    IMAGE_REG = /<img[^>]+src="?([^"]+)"?[^>]*>/g
    result = []
    while image = IMAGE_REG.exec(htmlString)
      result.push
        tag: image[0]
        src: image[1]
    result

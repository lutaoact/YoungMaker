'use strict'

angular.module('maui.components').filter 'embed', ($sce)->
  (input) ->
    url = String(input)
    result = switch true
      when /^<iframe(.*)<\/iframe>*/.test url
        # iframe. TODO: Not safe, not sure if the content in iframe is a video.
        url
      when /v.youku.com\/(.*)id_(.*).html/.test url
        # youku video http://v.youku.com/v_show/id_XODIwMDU0MDg0.html?f=23035007&ev=4&from=y1.3-idx-grid-1519-9909.86808-86807.7-1
        '<iframe height=498 width=510 src="http://player.youku.com/embed/' + url.replace(/.*id_(.*).html.*/,'$1') + '" frameborder=0 allowfullscreen></iframe>'
      when /v.qq.com\/cover(.*)vid=(.*)/.test url
        # qq video http://v.qq.com/cover/k/kd2yl4blio5xn17.html?vid=c0140yh6ew3
        '<iframe frameborder=0 src="http://v.qq.com/iframe/player.html?vid=' + url.replace(/.*vid=(.*)/,'$1') + '&tiny=0&auto=0" allowfullscreen></iframe>'
      else
        undefined
    $sce.trustAsHtml result


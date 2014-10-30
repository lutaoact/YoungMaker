'use strict'

angular.module('mauiApp')

.filter 'questionImage', ->
  QUESTION_IMAGE_REG = /<img[^>]*>/g
  (content) ->
    _.reduce content.match(QUESTION_IMAGE_REG), (images, tag) ->
      if (/<img .* class='question-image'>/).test(tag)
        images.push tag.replace(/.*src='(.*)' .*/, '$1')
      images
    , []

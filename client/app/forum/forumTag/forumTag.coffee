'use strict'

angular.module('budweiserApp').factory 'Tag', ()->
  genTags: (str)->
    (str.match /<div\s+class="tag\W.*?<\/div>/g)?.join('')

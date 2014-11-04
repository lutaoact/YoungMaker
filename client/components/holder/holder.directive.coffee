'use strict'

angular.module('maui.components').directive 'holderSrc', ->
  link: (scope, element, attrs) ->
    attrs.$set('data-src', attrs.holderSrc)
    Holder.run images:element[0]


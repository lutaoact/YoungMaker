'use strict'

angular.module('mauiApp').filter 'indexToABC', ->
  (index) -> String.fromCharCode(65+index)

'use strict'

angular.module('budweiserApp').filter 'indexToABC', ->
  (index) -> String.fromCharCode(65+index)

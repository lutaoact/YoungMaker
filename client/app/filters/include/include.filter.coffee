'use scrict'

angular.module('budweiserApp').filter 'include', ->
  (items, includes, itemKey, includeKey=itemKey) ->
    includeValues = if includeKey?.length > 0 then _.pluck(includes, includeKey) else includes
    _.filter items, (item) ->
      itemValue = if itemKey?.length > 0 then item[itemKey] else item
      includeValues.indexOf(itemValue) >= 0
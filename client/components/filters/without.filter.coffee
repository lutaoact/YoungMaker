'use strict'

angular.module('maui.components')

.filter 'without', ->
  (items, excepts, itemKey, exceptKey=itemKey) ->
    exceptValues = if exceptKey?.length > 0 then _.pluck(excepts, exceptKey) else excepts
    _.filter items, (item) ->
      itemValue = if itemKey?.length > 0 then item[itemKey] else item
      exceptValues.indexOf(itemValue) == -1



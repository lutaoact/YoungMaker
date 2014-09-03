'use strict'

angular.module('budweiserApp').filter 'paging', ->

  (items, itemsPerPage, currentPage) ->

    itemFromIndex = (currentPage - 1) * itemsPerPage
    itemToIndex = currentPage * itemsPerPage

    _.filter items, (item, index) ->
      index >=  itemFromIndex && index < itemToIndex

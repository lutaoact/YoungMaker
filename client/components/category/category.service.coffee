'use strict'

angular.module('mauiApp').factory 'Category', (Restangular, $q) ->
  allCategoriesQ = Restangular.all('categories').getList()

  find: (id)->
    if not id
      allCategoriesQ
    else
      deferred = $q.defer()
      allCategoriesQ.then (categories)->
        deferred.resolve _.find categories, (item)->
          item._id is id
      deferred.promise

  findRemotely: (id)->
    allCategoriesQ = Restangular.all('categories').getList()
    if not id
      allCategoriesQ
    else
      deferred = $q.defer()
      allCategoriesQ.then (categories)->
        deferred.resolve _.find categories, (item)->
          item._id is id
      deferred.promise



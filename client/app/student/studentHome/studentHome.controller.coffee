'use strict'

angular.module('budweiserApp').controller 'StudenthomeCtrl', ($scope) ->
  angular.extend $scope,
    filters: [
      {
        name: 'all'
      }
      {
        name: 'read'
      }
      {
        name: 'unread'
      }
    ]

    viewState:
      currentFilter: 'all'

    setFilter: (filter)->
      @viewState.currentFilter = filter

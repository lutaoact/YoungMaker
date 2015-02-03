angular.module('mauiApp')

.controller 'GroupListCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
) ->

  angular.extend $scope,
    groups = []
    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 6
      sort         : $state.params.sort ? 'postsCount'

    reload: (resetPageIndex) ->
      $scope.pageConf.currentPage = 1 if resetPageIndex
      $state.go 'groupList',
        page: $scope.pageConf.currentPage
        keyword: $scope.viewState.keyword
        sort: $scope.pageConf.sort

    search: ()->
      sortObj = {}
      if $scope.pageConf.sort
        sortObj[$scope.pageConf.sort] = -1
      sortObj.created = -1
      Restangular.all('groups').getList
        from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
        limit      : $scope.pageConf.itemsPerPage
        keyword    : $scope.viewState?.keyword
        sort       : JSON.stringify sortObj
      .then (groups)->
        $scope.groups = groups

  $scope.search()
  .then (groups)->
    $scope.groupsTotalCount = groups.$count

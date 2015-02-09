angular.module('mauiApp')

.controller 'GroupListCtrl', (
  Auth
  $scope
  $state
  Restangular
  $modal
) ->

  angular.extend $scope,
    groups = []
    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 6
      sort         : $state.params.sort #? 'postsCount'

    viewState:
      keyword: $state.params.keyword ? ''

    createGroup: ()->
      $modal.open
        templateUrl: 'app/group/editGroup/editGroupModal.html'
        controller: 'EditGroupModalCtrl'
        windowClass: 'bud-modal'
        size: 'sm'
        resolve:
          group: ->
            name: ''
      .result.then (newGroup) ->
        $state.go 'groupDetail.articleList', {groupId: newGroup._id}

    reload: (resetPageIndex) ->
      $scope.pageConf.currentPage = 1 if resetPageIndex
      $state.go 'groupList',
        page: $scope.pageConf.currentPage
        keyword: $scope.viewState?.keyword
        sort: $scope.pageConf.sort

    search: ()->
      sortObj = {}
      sortObj[$scope.pageConf.sort or 'postsCount'] = -1
      sortObj.created = -1
      Restangular.all('groups').getList
        from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
        limit      : $scope.pageConf.itemsPerPage
        keyword    : $scope.viewState?.keyword
        sort       : JSON.stringify sortObj
      .then (groups)->
        $scope.groups = groups

  $scope.search()

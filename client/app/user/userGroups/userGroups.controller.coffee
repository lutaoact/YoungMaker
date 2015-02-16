'use strict'

angular.module('mauiApp')

.controller 'UserGroupsCtrl', (
  $q
  $scope
  $modal
  $state
  Restangular
) ->

  angular.extend $scope,
    groups: null
    pageConf:
      keyword: $state.params.keyword ? undefined
      maxSize: 5
      currentPage: $state.params.page ? 1
      itemsPerPage: 20

    reload: ->
      $state.go $state.current,
        page: $scope.pageConf.currentPage
        keyword: $scope.pageConf.keyword

    createGroup: ->
      $modal.open
        templateUrl: 'app/group/editGroup/editGroupModal.html'
        controller: 'EditGroupModalCtrl'
        windowClass: 'bud-modal'
        size: 'sm'
        resolve:
          group: ->
            name: ''
      .result.then $scope.reload

  Restangular
    .all('groups')
    .getList(
      member: $state.params.userId
      keyword: $scope.pageConf.keyword
      from: ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
      limit: $scope.pageConf.itemsPerPage
    )
    .then (groups) ->
      $scope.groups = groups

'use scrict'

angular.module('mauiApp')

.controller 'GroupMemberListCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 20

    reload: (resetPageIndex) ->
      $scope.pageConf.currentPage = 1 if resetPageIndex
      $state.go $state.current.name,
        page: $scope.pageConf.currentPage


  Restangular.one('groups', $state.params.groupId).one('members')
  .get
    from  : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
    limit : $scope.pageConf.itemsPerPage
  .then (members)->
    $scope.groupMembers = members

    $scope.$emit 'updateTitle', ->
      if $scope.group
        "小组全部成员(#{members.count}) - #{$scope.group.name}"


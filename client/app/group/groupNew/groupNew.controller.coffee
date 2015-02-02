angular.module('mauiApp')

.controller 'GroupNewCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
) ->
  angular.extend $scope,
    groupData:
      title: null
      description: null

    # TODO: check if group title is unique
    createGroup: (form) ->
      if !form.$valid then return
      console.log $scope.groupData
      Restangular.all('groups').post($scope.groupData)
      .then (data) ->
        notify
          message: '小组已创建'
          classes: 'alert-success'
      # TODO: state go to group page
        $state.go 'group', {groupId: data._id}
      .catch (error) ->
        notify
          message: '创建小组出错啦：' + error
          classes: 'alert-danger'
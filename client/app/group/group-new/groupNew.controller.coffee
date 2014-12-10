angular.module('mauiApp')

.controller 'GroupNewCtrl', (
  Auth
  $scope
  $state
  Restangular
) ->
  angular.extend $scope,
    groupData:
      title: null
      info: null

    createGroup: (form) ->
      if !form.$valid then return
      console.log $scope.groupData
      Restangular.all('articles').post($scope.groupData)
      .then ->
      notify
        message: '小组已创建'
        classes: 'alert-success'
      # TODO: state go to group page
#      $state.go 'settings.myArticles'
      .catch (error) ->
      notify
        message: '创建小组出错啦：' + error
        classes: 'alert-danger'
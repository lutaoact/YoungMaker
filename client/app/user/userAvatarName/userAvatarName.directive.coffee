'use strict'

angular.module('mauiApp').directive 'userAvatarName', ->
  restrict: 'E'
  replace: true
  scope:
    user: '='
    size: '@'
  templateUrl: 'app/user/userAvatarName/userAvatarName.html'

  controller: ($scope)->
    if !$scope.size
      $scope.size = 'xs'


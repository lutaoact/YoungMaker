angular.module('mauiApp')

.controller 'CourseListCtrl', (
  Auth
  $scope
  $state
  Restangular
  CurrentUser
  notify
) ->

  angular.extend $scope,
    courses: []
    me: CurrentUser

  Restangular.all('courses').getList({from: 0, limit: 10})
  .then (courses)->
    $scope.courses = _.union $scope.courses, courses


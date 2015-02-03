angular.module('mauiApp')

.controller 'CourseListCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
) ->

  angular.extend $scope,
    courses: []

  Restangular.all('courses').getList({from: 0, limit: 10})
  .then (courses)->
    $scope.courses = _.union $scope.courses, courses

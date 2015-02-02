'use strict'

angular.module 'mauidmin'
.config ($stateProvider) ->
  $stateProvider
  .state 'course',
    url: '/courses/:courseId'
    templateUrl: 'admin/course/courseDetail.html'
    controller: 'CourseDetailCtrl'
    authenticate: true

.controller 'CourseDetailCtrl', ($scope, Restangular, $state) ->

  if $state.courseId
    Restangular.one('courses', $state.courseId).get()
    .then (course)->
      $scope.course = course
  else
    $scope.course = Restangular.one('courses')

  angular.extend $scope,
    course: undefined

    saveCourse: ()->
      if $scope.course._id
        $scope.course.put()
        .then (course)->
          angular.extend $scope.course, course
      else
        Restangular.all('courses').post $scope.course
        .then (course)->
          angular.extend $scope.course, course



'use strict'

angular.module('budweiserApp').controller 'StudentCourseListCtrl'
, (
  $scope
  User
  Auth
  Restangular
  $http
  $upload
  notify
  Courses
) ->
  angular.extend $scope,
    filters: [
      {
        name: 'all'
      }
      {
        name: 'read'
      }
      {
        name: 'unread'
      }
    ]

    viewState:
      currentFilter: 'all'

    setFilter: (filter)->
      @viewState.currentFilter = filter

    courses: undefined

    loadCourses: ()->
      $scope.courses = Courses

  $scope.loadCourses()

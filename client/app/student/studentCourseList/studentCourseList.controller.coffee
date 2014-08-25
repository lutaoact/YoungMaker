'use strict'

angular.module('budweiserApp').controller 'StudentCourseListCtrl'
, ($scope, User, Auth, Restangular, $http, $upload, notify) ->
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
      Restangular.all('courses').getList().then (courses)->
        $scope.courses = courses
      , (err)->
        console.log err
        notify
          message: '权限错误'
          template: 'components/alert/failure.html'

  $scope.loadCourses()

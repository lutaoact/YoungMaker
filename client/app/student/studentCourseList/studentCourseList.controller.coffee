'use strict'

angular.module('budweiserApp').controller 'StudentCourseListCtrl'
, (
  User
  Auth
  $http
  $scope
  notify
  socket
  $upload
  Courses
) ->

  # TODO 移动到对应的地方
  socket.setHandler 'message', (event) ->
    console.debug 'socket.onmessag:', event

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
      limitHeight: true

    setFilter: (filter)->
      @viewState.currentFilter = filter

    courses: undefined

    loadCourses: ()->
      $scope.courses = Courses


  $scope.loadCourses()

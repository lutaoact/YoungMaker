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
  SockJSClient
) ->


  # sockjs = SockJSClient.get()
  # console.debug sockjs
  # console.debug $scope
  # $scope.sockjsData = "test test test"
  # sockjs.onmessage = (msg) ->
  #   console.log 'received quiz msg...'
  #   console.debug msg
  #   msgData = JSON.parse msg.data
  #   questionId = msgData.payload.questionId
  #   $scope.sockjsData = questionId
  #   $scope.$apply()

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

'use strict'

angular.module('budweiserApp').controller 'StudentCourseListCtrl'
, (
  User
  Auth
  $http
  $scope
  notify
  $upload
  Courses
  Restangular
  timetableHelper
) ->

  angular.extend $scope,

    courses: undefined

    loadCourses: ()->
      $scope.courses = Courses

    startCourse: (event)->
      console.log event

    loadTimetable: ()->
      Restangular.all('schedules').getList()
      .then (schedules)->
        # Compose this week then set handle
        $scope.eventSouces = timetableHelper.genStudentTimetable(schedules)
        $scope.dayChangedHandle = (day)->
          $scope.eventSouces = timetableHelper.genStudentTimetable($scope.schedules, moment(day))
        $scope.schedules = schedules

    dayChangedHandle: undefined

    eventSouces: undefined

  $scope.loadCourses()
  $scope.loadTimetable()

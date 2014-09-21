'use strict'

angular.module('budweiserApp').controller 'TeacherHomeCtrl', (
  Auth
  $modal
  $scope
  Courses
  Categories
  Restangular
  timetableHelper
) ->

  angular.extend $scope,
    loadTimetable: ()->
      Restangular.all('schedules').getList()
      .then (schedules)->
        # Compose this week then set handle
        $scope.eventSouces = timetableHelper.genTeacherTimetable(schedules)
        $scope.dayChangedHandle = (day)->
          $scope.eventSouces = timetableHelper.genTeacherTimetable($scope.schedules, moment(day))
        $scope.schedules = schedules

    dayChangedHandle: undefined

    eventSouces: undefined

    courses: Courses

    createNewCourse: ->
      $modal.open
        templateUrl: 'app/teacher/teacherCourse/teacherNewCourse.html'
        controller: 'TeacherNewCourseCtrl'
        resolve:
          categories: -> Categories
      .result.then (newCourse) ->
        $scope.courses.push newCourse

  $scope.loadTimetable()

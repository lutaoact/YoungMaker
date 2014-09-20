'use strict'

angular.module('budweiserApp').controller 'TeacherHomeCtrl', (
  Auth
  $scope
  Classes
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

    newCourse: undefined
    courses: Courses
    classes: Classes
    categories: Categories

    switchNewCourse: (create = true) ->
      if create
        $scope.newCourse =
          owners:[Auth.getCurrentUser()]
      else
        $scope.newCourse = undefined

    createCallback: (course) ->
      delete $scope.newCourse
      $scope.courses.push course

    cancelCallback: ->
      delete $scope.newCourse

  $scope.loadTimetable()

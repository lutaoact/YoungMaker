'use strict'

angular.module('budweiserApp').controller 'TeacherHomeCtrl', (
  Auth
  $scope
  $state
  Classes
  Courses
  $location
  $timeout
  $document
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

    deleteCallback: (course) ->
      index = $scope.courses.indexOf(course)
      $scope.courses.splice(index, 1)

    navToCourse: (courseId) -> $timeout ->
      id = $location.hash() ? ''
      if id.indexOf(courseId) != -1
        courseEle = angular.element(document.getElementById(id))
        $document.scrollToElement(courseEle, 60, 500)

  $scope.loadTimetable()

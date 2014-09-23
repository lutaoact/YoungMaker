'use strict'

angular.module('budweiserApp').controller 'TeacherCourseStatsCtrl', (
  Auth
  $http
  notify
  $scope
  $state
  $upload
  Classes
  fileUtils
  Categories
  $rootScope
  Restangular
  $q
) ->

  loadCourse = ()->
    Restangular.one('courses',$state.params.courseId).get()
    .then (course)->
      $scope.course = course

  angular.extend $scope,

    course: undefined

    classes: Classes

    allStudents: undefined

    viewState: {}

    toggleClasse: (classe)->
      if @viewState.expandClasse == classe
        @viewState.expandClasse = undefined
      else
        @viewState.expandClasse = classe

    loadStudents: ->
      allStudents = []
      $q.all($scope.classes.map (classe)->
        classe.all('students').getList()
        .then (students)->
          allStudents = allStudents.concat students
          students.forEach (student)->
            student.$classeInfo =
              name: classe.name
              yearGrade: classe.yearGrade
          classe.$students = students
      ).then ->
        $scope.allStudents = _.indexBy allStudents, '_id'

  loadCourse()
  $scope.loadStudents()

.controller 'TeacherCourseStatsMainCtrl',
(
  $scope
  $state
)->
  $scope.viewState.student = undefined

  $scope.stateParams = $state.params

.controller 'TeacherCourseStatsStudentCtrl',
(
  $scope
  $state
)->
  $scope.stateParams = $state.params

  $scope.$watch 'allStudents', (value)->
    if value
      $scope.viewState.student = value[$state.params.studentId]
      $scope.student = value[$state.params.studentId]


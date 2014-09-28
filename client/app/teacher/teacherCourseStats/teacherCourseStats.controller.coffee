'use strict'

angular.module('budweiserApp').controller 'TeacherCourseStatsCtrl', (
  Auth
  $http
  notify
  $scope
  $state
  $upload
  fileUtils
  Categories
  $rootScope
  Restangular
  $q
) ->

  loadCourse = ()->
    Restangular.one('courses',$state.params.courseId).get()
    .then (course)->
      $scope.classes = course.classes
      $scope.course = course

  angular.extend $scope,

    course: undefined

    allStudentsDict: undefined

    allStudentsArray: []

    viewState: {}

    toggleClasse: (classe)->
      if @viewState.expandClasse == classe
        @viewState.expandClasse = undefined
      else
        @viewState.expandClasse = classe

    loadStudents: ->
      $q.all($scope.classes.map (classe)->
        Restangular.all("classes/#{classe._id}/students").getList()
        .then (students)->
          $scope.allStudentsArray = $scope.allStudentsArray.concat students
          students.forEach (student)->
            student.$classeInfo =
              name: classe.name
              yearGrade: classe.yearGrade
          classe.$students = students
      ).then ->
        $scope.allStudentsDict = _.indexBy $scope.allStudentsArray, '_id'

  loadCourse().then $scope.loadStudents

.controller 'TeacherCourseStatsMainCtrl',
(
  $scope
  $state
  chartUtils
)->
  $scope.viewState.student = undefined

  chartUtils.genStatsOnScope $scope, $state.params.courseId

.controller 'TeacherCourseStatsStudentCtrl',
(
  $scope
  $state
  chartUtils
)->

  $scope.$watch 'allStudentsDict', (value)->
    if value
      $scope.viewState.student = value[$state.params.studentId]
      $scope.student = value[$state.params.studentId]

  chartUtils.genStatsOnScope $scope, $state.params.courseId, $state.params.studentId




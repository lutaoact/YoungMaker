'use strict'

angular.module('budweiserApp').controller 'TeacherCourseStatsCtrl', (
  $q
  $scope
  $state
  Navbar
  Courses
  Restangular
) ->

  course = _.find Courses, _id:$state.params.courseId

  Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"
  $scope.$on '$destroy', Navbar.resetTitle

  angular.extend $scope,
    course: course
    classes: course.classes
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

  $scope.loadStudents()

.controller 'TeacherCourseStatsMainCtrl', (
  $scope
  $state
  chartUtils
) ->
  $scope.viewState.student = undefined

  chartUtils.genStatsOnScope $scope, $state.params.courseId

.controller 'TeacherCourseStatsStudentCtrl', (
  $scope
  $state
  chartUtils
) ->

  $scope.$watch 'allStudentsDict', (value)->
    if value
      $scope.viewState.student = value[$state.params.studentId]
      $scope.student = value[$state.params.studentId]

  chartUtils.genStatsOnScope $scope, $state.params.courseId, $state.params.studentId




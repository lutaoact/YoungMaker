'use strict'

angular.module 'mauidmin'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'admin/main/main.html'
    controller: 'MainCtrl'
    authenticate: true

.controller 'MainCtrl', ($scope, Restangular, notify) ->

  Restangular.all('courses').getList()
  .then (courses)->
    $scope.courses = courses

  Restangular.all('grade_subjects').getList()
  .then (gradeSubjects)->
    $scope.gradeSubjects = gradeSubjects

  angular.extend $scope,
    courses: undefined
    gradeSubjects: undefined
    newGradeSubject: {}

    createGradeSubject: ()->
      Restangular.all('grade_subjects').post $scope.newGradeSubject
      .then (newGradeSubject)->
        $scope.gradeSubjects?.push newGradeSubject
        $scope.newGradeSubject = {}
        notify
          message: newGradeSubject

    deleteGradeSubject: (gradeSubject)->
      gradeSubject.remove()
      .then (data)->
        $scope.gradeSubjects?.splice $scope.gradeSubjects.indexOf(gradeSubject), 1
        notify
          message: data

    updateGradeSubject: (gradeSubject)->
      gradeSubject.put()
      .then (data)->
        angular.extend gradeSubject, data
        notify
          message: data






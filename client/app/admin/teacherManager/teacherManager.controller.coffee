'use strict'

angular.module('budweiserApp').controller 'TeacherManagerCtrl', (
  $modal
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    teachers: null

    reloadTeachers: ->
      Restangular.all('users').getList(role:'teacher')
      .then (teachers) ->
        $scope.teachers = teachers

    viewTeacher: (teacher) ->
      $state.go('admin.teacherManager.detail', teacherId:teacher._id)

  $scope.reloadTeachers()


'use strict'

angular.module('budweiserApp').directive 'teacherCourseForm', ->
  restrict: 'EA'
  replace: true
  controller: 'TeacherCourseFormCtrl'
  templateUrl: 'app/teacher/teacherCourse/teacherCourseForm.html'
  scope:
    course: '='
    categories: '='
    deleteCallback: '&'

angular.module('budweiserApp').controller 'TeacherCourseFormCtrl', (
  $http
  $scope
  $modal
) ->

  angular.extend $scope,

    saving: false
    editingInfo: null

    switchEdit: ->
      $scope.editingInfo =
        if !$scope.editingInfo?
          _.pick $scope.course, [
            'name'
            'info'
            'categoryId'
            'thumbnail'
          ]
        else
          null

    deleteCourse: ->
      course = $scope.course
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除课程'
          message: -> "确认要删除《#{course.name}》？"
      .result.then ->
        course.remove().then ->
          $scope.deleteCallback?($course:course)

    saveCourse: (form)->
      unless form.$valid then return
      $scope.saving = true
      course = $scope.course
      editingInfo = $scope.editingInfo
      course.patch(editingInfo)
      .then (newCourse) ->
        course.__v = newCourse.__v
        $scope.editingInfo = null
        $scope.saving = false
        angular.extend course, editingInfo

    onThumbUploaded: (key) ->
      $scope.editingInfo.thumbnail = key

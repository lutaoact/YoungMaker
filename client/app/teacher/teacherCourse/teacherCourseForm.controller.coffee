'use strict'

angular.module('mauiApp').directive 'teacherCourseForm', ->
  restrict: 'EA'
  replace: true
  controller: 'TeacherCourseFormCtrl'
  templateUrl: 'app/teacher/teacherCourse/teacherCourseForm.html'
  scope:
    course: '='
    categories: '='
    deleteCallback: '&'

angular.module('mauiApp').controller 'TeacherCourseFormCtrl', (
  $http
  $scope
  notify
  Navbar
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
        Navbar.setTitle course.name, "teacher.course({courseId:'#{course._id}'})"
        notify
          message:'课程信息已保存'
          classes:'alert-success'

    onThumbUploaded: (key) ->
      $scope.editingInfo.thumbnail = key

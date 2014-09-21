'use strict'

angular.module('budweiserApp').directive 'teacherCourseForm', ->
  restrict: 'EA'
  replace: true
  controller: 'TeacherCourseFormCtrl'
  templateUrl: 'app/teacher/teacherCourse/teacherCourseForm.html'
  scope:
    editable: '='
    course: '='
    categories: '='
    deleteCallback: '&'
    cancelCallback: '&'
    updateCallback: '&'
    createCallback: '&'

angular.module('budweiserApp').controller 'TeacherCourseFormCtrl', (
  $http
  $scope
  $modal
  $state
) ->

  angular.extend $scope,

    editing: !$scope.course._id?

    switchEditing: (course) ->
      if !$scope.editable
        $state.go('teacher.course', courseId:$scope.course._id)
        return
      $scope.editing = !$scope.editing
      if !$scope.editing
        $scope.cancelCallback?($course:course)

    deleteCourse: (course) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除课程'
          message: -> "确认要删除《#{course.name}》吗？"
      .result.then ->
        course.remove().then ->
          $scope.deleteCallback?($course:course)

    saveCourse: (course, form)->
      unless form.$valid then return
      $scope.editing = false
      # update exists
      course.patch(
        name: course.name
        info: course.info
        categoryId: course.categoryId
      )
      .then (newCourse) ->
        course.__v = newCourse.__v
        $scope.updateCallback?($course:newCourse)

    onThumbUploaded: (key) ->
      $scope.course.thumbnail = key
      $scope.course?.patch?(thumbnail: $scope.course.thumbnail)
      .then (newCourse) ->
        $scope.course.__v = newCourse.__v

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
    cancelCallback: '&'
    updateCallback: '&'
    createCallback: '&'

angular.module('budweiserApp').controller 'TeacherCourseFormCtrl', (
  $http
  $scope
  $state
  $upload
  fileUtils
  Restangular
) ->

  angular.extend $scope,

    editing: !$scope.course._id?

    switchEditing: (course) ->
      $scope.editing = !$scope.editing
      if !$scope.editing
        $scope.cancelCallback?($course:course)

    deleteCourse: (course) ->
      course.remove().then ->
        $scope.deleteCallback?($course:course)

    saveCourse: (course, form)->
      unless form.$valid then return
      $scope.editing = false
      if course._id?
        # update exists
        course.patch(
          name: course.name
          info: course.info
          categoryId: course.categoryId
        )
        .then (newCourse) ->
          course.__v = newCourse.__v
          $scope.updateCallback?($course:newCourse)
      else
        # create new
        Restangular.all('courses').post(course)
        .then (newCourse)->
          $scope.createCallback?($course:newCourse)

    onThumbUploaded: (key) ->
      $scope.course.thumbnail = key
      $scope.course?.patch?(thumbnail: $scope.course.thumbnail)
      .then (newCourse) ->
        $scope.course.__v = newCourse.__v

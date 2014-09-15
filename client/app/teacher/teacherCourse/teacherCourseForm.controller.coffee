'use strict'

angular.module('budweiserApp').directive 'teacherCourseForm', ->
  restrict: 'EA'
  replace: true
  controller: 'TeacherCourseFormCtrl'
  templateUrl: 'app/teacher/teacherCourse/teacherCourseForm.html'
  scope:
    course: '='
    courses: '='
    categories: '='

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
      $state.go('teacher.home') if !course?._id?


    deleteCourse: (course) ->
      course.remove().then ->
        index = $scope.courses.indexOf(course)
        $scope.courses.splice(index, 1)

    saveCourse: (course, form)->
      unless form.$valid then return
      if course._id?
        # update exists
        course.patch(
          name: course.name
          info: course.info
          categoryId: course.categoryId
        )
        .then (newCourse) ->
          course.__v = newCourse.__v
      else
        # create new
        Restangular.all('courses').post(course)
        .then (newCourse)->
          $scope.courses.push(newCourse)
          $state.go('teacher.home')

    onThumbUploaded: (key) ->
      $scope.course.thumbnail = key
      $scope.course?.patch?(thumbnail: $scope.course.thumbnail)
      .then (newCourse) ->
        $scope.course.__v = newCourse.__v

'use strict'

angular.module('budweiserApp').controller 'TeacherCourseDetailCtrl', (
  Auth
  $http
  notify
  $scope
  $state
  $upload
  Classes
  qiniuUtils
  Categories
  Restangular
) ->

  loadCourse = ->
    if $state.params.id is 'new'
      $scope.course = {}
    else
      # load courses
      Restangular.one('courses',$state.params.id).get()
      .then (course)->
        $scope.course = course
        Restangular.all('lectures').getList(courseId:course._id)
        .then (lectures) ->
          $scope.course.$lectures = _.map($scope.course.lectureAssembly, (id) -> _.find(lectures, _id:id))


  angular.extend $scope,

    categories: Categories
    classes: Classes
    course: undefined
    state:
      uploading: false
      uploadProgress: ''

    deleteLecture: (lecture)->
      lecture.remove(courseId:$scope.course._id)
      .then ->
        lectures = $scope.course.$lectures
        lectures.splice(lectures.indexOf(lecture), 1)

    deleteCourse: (course) ->
      course.remove().then ->
        $state.go('teacher.home')

    saveCourse: (course, form)->
      unless form.$valid then return
      if course._id?
        # update exists
        Restangular.copy(course).put()
      else
        # create new
        Restangular.all('courses').post(course)
        .then (newCourse)-> $scope.course = newCourse

    selectClasse: (classe) ->
      classes = $scope.course.classes
      $scope.course.patch(classes:
        if _.contains(classes, classe._id)
          _.without(classes, classe._id)
        else
          _.union(classes, [classe._id])
      )
      .then (newCourse) ->
        $scope.course.classes = newCourse.classes


    onImageSelect: (files) ->
      $scope.state.uploading = true
      qiniuUtils.uploadFile
        files: files
        validation:
          max: 2*1024*1024
          accept: 'image'
        success: (key) ->
          $scope.state.uploading = false
          logoStyle ='?imageView2/2/w/210/h/140'
          $scope.course.thumbnail = key + logoStyle
          $scope.course?.patch?(thumbnail: $scope.course.thumbnail)
        fail: (error)->
          $scope.state.uploading = false
          notify(error)
        progress: (speed,percentage, evt)->
          $scope.state.uploadProgress = parseInt(100.0 * evt.loaded / evt.total) + '%'

  $scope.$on 'ngrr-reordered', ->
    $scope.course.patch lectureAssembly:_.pluck($scope.course.$lectures, '_id')

  loadCourse()

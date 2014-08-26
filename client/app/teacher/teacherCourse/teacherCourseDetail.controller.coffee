'use strict'

angular.module('budweiserApp').controller 'TeacherCourseDetailCtrl', (
  Auth
  $http
  $scope
  $state
  $upload
  notify
  qiniuUtils
  Restangular
) ->

  angular.extend $scope,

    course: undefined
    uploadState:
      uploading: false
      progress: ''

    deleteLecture: (lecture)->
      Restangular.one('lectures', lecture._id).remove(courseId:$scope.course._id)
      .then ->
        lectures = $scope.course.$lectures
        lectures.splice(lectures.indexOf(lecture), 1)

    saveCourse: (course, form)->
      course.put() if form.$valid

    onImageSelect: (files) ->
      $scope.uploadState.uploading = true
      qiniuUtils.uploadFile
        files: files
        validation:
          max: 2*1024*1024
          accept: 'image'
        success: (key) ->
          logoStyle ='?imageView2/2/w/210/h/140'
          $scope.course.thumbnail = key + logoStyle
          $scope.course.patch(thumbnail: $scope.course.thumbnail)
          .then ()->
            $scope.uploadState.uploading = false
        fail: (error)->
          $scope.uploadState.uploading = false
          notify(error)
        progress: (speed,percentage, evt)->
          $scope.uploadState.progress = parseInt(100.0 * evt.loaded / evt.total) + '%'

  $scope.$on 'ngrr-reordered', ()->
    newLectureAssembly = []
    for index in [0..($scope.course.$lectures.length - 1)]
      newLectureAssembly.push $scope.course.$lectures[index]._id
    $scope.course.patch({lectureAssembly:newLectureAssembly})

  # load courses
  Restangular.one('courses',$state.params.id).get()
  .then (course)->
    $scope.course = course
    $scope.course.$lectures = Restangular.all('lectures').getList(courseId:course._id).$object


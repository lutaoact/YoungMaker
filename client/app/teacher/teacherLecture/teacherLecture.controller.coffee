'use strict'

angular.module('budweiserApp').controller 'TeacherLectureCtrl', (
  Auth
  $http
  $scope
  $state
  notify
  $upload
  $location
  qiniuUtils
  Restangular
) ->

  angular.extend $scope,

    slides: []
    lecture: undefined
    $state: $state
    isPptProcessing: false

    saveLecture: (lecture,form)->
      unless form.$valid then return
      (
        if lecture._id?
          # update exists
          Restangular.copy(lecture).put(courseId: $state.params.courseId)
        else
          # create new
          Restangular.all('lectures').post(lecture, courseId:$state.params.courseId)
      )
      .then ->
        notify
          message:'课时已保存'
          template:'components/alert/success.html'
        $state.go('teacher.course', id: $state.params.courseId)

    onPPTSelect: (files)->
      qiniuUtils.uploadFile
        files: files
        validation:
          max: 50 * 1024 * 1024
          accept: 'ppt'
        success: (key)->
          $scope.excelUrl = key
          $http.post('/api/users/sheet',{key:key,orgId: Auth.getCurrentUser().orgId})
          .success (result)->
            console.log result
          .error (error)->
            console.log error
          .finally ->
            $scope.isPptProcessing = false
        fail: (error)->
          notify(error)
        progress: (speed, percentage, evt)->
          notify($scope.uploadingP)

    onImagesSelect: (files)->
      qiniuUtils.bulkUpload
        files: files
        validation:
          max: 10*1024*1024
          accept: 'image'
        success: (keys)->
          $scope.slides = keys
          # $scope.lecture.patch {slides: keys}
        fail: (error)->
          notify(error)
        progress: (speed,percentage, evt)->
          notify(speed + ' k/s at ' +  percentage)

  if $state.params.id is 'new'
    $scope.lecture = {}
  else
    Restangular.one('courses', $state.params.courseId).get()
    .then (course)->
      $scope.course = course
      $scope.lecture = Restangular.one('lectures', $state.params.id).get().$object


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

    categories: Restangular.all('categories').getList().$object
    course: undefined
    state:
      uploading: false
      uploadProgress: ''

    deleteLecture: (lecture)->
      Restangular.one('lectures', lecture._id).remove(courseId:$scope.course._id)
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
        course.put()
      else
        # create new
        Restangular.all('courses').post(course)
        .then (newCourse)-> $scope.course = newCourse

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

  $scope.$on 'ngrr-reordered', ()->
    newLectureAssembly = []
    for index in [0..($scope.course.$lectures.length - 1)]
      newLectureAssembly.push $scope.course.$lectures[index]._id
    $scope.course.patch({lectureAssembly:newLectureAssembly})

  if $state.params.id is 'new'
    $scope.course = {}
  else
    # load courses
    Restangular.one('courses',$state.params.id).get()
    .then (course)->
      $scope.course = course
      $scope.course.$lectures = Restangular.all('lectures').getList(courseId:course._id).$object


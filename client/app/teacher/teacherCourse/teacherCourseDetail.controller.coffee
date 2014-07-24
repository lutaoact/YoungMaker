'use strict'

angular.module('budweiserApp').controller 'TeacherCourseDetailCtrl', ($scope,$state,Restangular,Auth, $http,$upload,$location) ->
  $scope.message = 'Hello'
  $scope.course = null
  $scope.keypoints = []


  Restangular.one('courses',$state.params.id).get()
  .then (course)->
    $scope.course = course
    $scope.course.all('lectures').getList()
    .then (lectures)->
      $scope.course.$lectures = lectures
  , (error)->
    console.log error

  $scope.onFileSelect = (files)->
    if not files? or files.length < 1
      return
    #TODO: check file type by name or file type. pptx: application/vnd.openxmlformats-officedocument.presentationml.presentation
    if not /^.*\.(png|PNG|jpg|JPG|jpeg|JPEG|gif|GIF|bmp|BMP)$/.test files[0].name
      $scope.invalid = true
      return
    if files[0].size > 2 * 1024 * 1024
      $scope.invalid = true
      return

    $scope.isUploading = true
    file = files[0]
    # get upload token
    console.log file
    $http.get('/api/qiniu/uptoken')
    .success (uploadToken)->
      qiniuParam =
        'key': uploadToken.random + '/' + ['thumbnail', file.name.split('.').pop()].join('.')
        'token': uploadToken.token
      $scope.upload = $upload.upload
        url: 'http://up.qiniu.com'
        method: 'POST'
        data: qiniuParam
        withCredentials: false
        file: file
        fileFormDataName: 'file'
      .progress (evt)->
        $scope.uploadingP = parseInt(100.0 * evt.loaded / evt.total)
      .success (data) ->
        # file is uploaded successfully
        console.log data
        logoStyle ='?imageView2/2/w/210/h/140'
        $scope.course.thumbnail = data.key + logoStyle
        $scope.course.patch({thumbnail:$scope.course.thumbnail})
        .then ()->
          $scope.isUploading = false
      .error (response)->
        console.log response

  $scope.$on 'ngrr-reordered', ()->
    newLectureAssembly = []
    for index in [0..($scope.course.$lectures.length - 1)]
      newLectureAssembly.push $scope.course.$lectures[index]._id
    $scope.course.patch({lectureAssembly:newLectureAssembly})

  $scope.deleteLecture = (lecture)->
    $scope.course.one('lectures',lecture._id).remove()
    .then ()->
      $scope.course.$lectures.splice($scope.course.$lectures.indexOf(lecture),1)

  $scope.createKeypoint = (keypoint)->
    $scope.keypoints.push({_id:'new',name:keypoint})

  $scope.keypoints = [{
    _id:'1234'
    name:'牛顿第一定律'
    },{
    _id:'1234'
    name:'牛顿第二定律'
    },{
    _id:'1234'
    name:'牛顿第三定律'
    },{
    _id:'1234'
    name:'万有引力'
    },{
    _id:'1234'
    name:'声音的发生'
    },{
    _id:'1234'
    name:'声音的传播'
    },{
    _id:'1234'
    name:'光源'
    },{
    _id:'1234'
    name:'光的直线传播'
    }]

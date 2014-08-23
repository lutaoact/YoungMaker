'use strict'

angular.module('budweiserApp').controller 'TeacherLectureCtrl', ($scope,$state,Restangular,Auth, $http,$upload,$location,notify, qiniuUtils) ->

  loadCourse = ()->
    if $scope.$stateParams.id and $scope.$stateParams.id is 'new'
      $scope.lecture = {courseId:$scope.$stateParams.courseId}
    else if $scope.$stateParams.id
      Restangular.one('courses',$scope.$stateParams.courseId).get()
      .then (course)->
        $scope.course = course
        Restangular.all('knowledge_points').getList({categoryId:course.categoryId})
        .then (kps)->
          $scope.knowledgePoints = kps
        $scope.course.one('lectures',$scope.$stateParams.id).get()
        .then (lecture)->
          $scope.lecture = lecture
          $scope.lecture.all('knowledge_points').getList()
          .then (kps)->
            $scope.lecture.$knowledgePoints = kps

  angular.extend $scope,
    lecture: null

    $stateParams: $state.params

    isPptProcessing: false

    onPPTSelect: (files)->
      qiniuUtils.uploadFile files, {max: 50 * 1024 * 1024, accept:'ppt'}
      , (key)->
        $scope.excelUrl = key
        $http.post('/api/users/sheet',{key:key,orgId:Auth.getCurrentUser().orgId})
        .success (result)->
          console.log result
        .error (error)->
          console.log error
        .finally ()->
          $scope.isPptProcessing = false
      , (error)->
        notify(error)
        console.log error
      , (speed,percentage, evt)->
        notify($scope.uploadingP)

    slides: []

    onImagesSelect: (files)->
      qiniuUtils.bulkUpload files, {max:10*1024*1024,accept:'image'}, (keys)->
        $scope.slides = keys
        # $scope.lecture.patch {slides: keys}
      , (error)->
        notify(error)
        console.log error
      , (speed,percentage, evt)->
        notify(speed + ' k/s at ' +  percentage)

    addKnowledgePoint: (knowledgePoint)->
      if knowledgePoint?
        knowledgePoint.categoryId = $scope.course.categoryId
        $scope.lecture.all('knowledge_points').post(knowledgePoint)
        .then (kp)->
          $scope.lecture.$knowledgePoints.push kp
          console.log kp
          # $scope.keypoints.push({_id:'new',name:keypoint})

    deleteKnowledgePonit: (kp)->
      kp.remove()
      .then ()->
        $scope.lecture.$knowledgePoints.splice($scope.lecture.$knowledgePoints.indexOf(kp),1)

    saveLecture: (lecture,form)->
      if form.$valid
        if not lecture._id
          #post
          $scope.course.all('lectures').post(lecture)
          .then (data)->
            notify({message:'课时已保存',template:'components/alert/success.html'})
            $state.go('teacher.lectureDetail',{courseId:$scope.$stateParams.courseId,id:data._id})
        else
          #put
          lecture.put()

    patchLecture: ()->



  loadCourse()


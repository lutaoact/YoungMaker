'use strict'

angular.module('budweiserApp').controller 'StudentCourseDetailCtrl'
, ($scope, User, Auth, Restangular, $http, $upload, notify, $state) ->
  angular.extend $scope,

    course: null

    $stateParams: $state.params

    saveCourse: (course)->
      if not course._id
        #post
        Restangular.all('courses').post(course)
        .then (data)->
          notify({message:'课程已保存',template:'components/alert/success.html'})
          $state.go('student.courseDetail',{courseId:data._id})
      else
        #put
        course.put()
        .then (data)->
          angular.extend course, data
          notify({message:'课程已保存',template:'components/alert/success.html'})

    patchCourse: (course, field)->
      if not course._id
        #post
        Restangular.all('courses').post(course)
        .then (data)->
          notify({message:'课程已保存',template:'components/alert/success.html'})
          $state.go('student.courseDetail',{courseId:data._id})
      else
        #put
        patch = {}
        patch[field] = course[field]
        course.patch(patch)
        .then (data)->
          angular.extend $scope.course, data
          notify({message:'课程已保存',template:'components/alert/success.html'})

    loadCourse: ()->
      if @$stateParams.courseId and @$stateParams.courseId is 'new'
        @course = Restangular.one('courses')
      else if $state.params.courseId
        Restangular.one('courses',@$stateParams.courseId).get()
        .then (course)->
          $scope.course = course

    deleteCourse: (course)->
      course.remove()
      .then ()->
        $state.go('student.courseList')

  $scope.loadCourse()

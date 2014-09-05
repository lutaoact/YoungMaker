'use strict'

angular.module('budweiserApp').controller 'StudentCourseDetailCtrl'
, (
  $scope
  Restangular
  notify
  $state
  Category
  $rootScope
  $modal
  Courses
) ->

  $rootScope.additionalMenu = [
    {
      title: '课程主页<i class="fa fa-home"></i>'
      link: "student.courseDetail({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '讨论<i class="fa fa-comments-o"></i>'
      link: "forum.course({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '统计<i class="fa fa-bar-chart-o"></i>'
      link: "student.courseStats({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
  ]

  $scope.$on '$destroy', ()->
    $rootScope.additionalMenu = []

  angular.extend $scope,

    course: null

    $stateParams: $state.params

    saveCourse: (course)->
      if not course._id
        #post
        Restangular.all('courses').post(course)
        .then (data)->
          notify
            message:'课程已保存'
            template:'components/alert/success.html'
          $state.go 'student.courseDetail',
            courseId: data._id
      else
        #put
        course.put()
        .then (data)->
          angular.extend course, data
          notify
            message: '课程已保存'
            template: 'components/alert/success.html'

    patchCourse: (course, field)->
      if not course._id
        #post
        Restangular.all('courses').post(course)
        .then (data)->
          notify
            message: '课程已保存'
            template: 'components/alert/success.html'
          $state.go 'student.courseDetail',
            courseId: data._id
      else
        #put
        patch = {}
        patch[field] = course[field]
        course.patch(patch)
        .then (data)->
          angular.extend $scope.course, data
          notify
            message: '课程已保存'
            template: 'components/alert/success.html'

    loadCourse: ()->
      if @$stateParams.courseId and @$stateParams.courseId is 'new'
        @course = Restangular.one('courses')
      else if $state.params.courseId
        Restangular.one('courses',@$stateParams.courseId).get()
        .then (course)->
          $scope.course = course
          Category.find course.categoryId
        .then (category)->
          $scope.course.$category = category

    deleteCourse: (course)->
      course.remove()
      .then ()->
        $state.go 'student.courseList'

    loadLectures: ()->
      if $state.params.courseId
        Restangular.all('lectures').getList({courseId: $state.params.courseId})
        .then (lectures)->
          $scope.course.$lectures = lectures

    openQuickNav: ()->
      $modal.open
        templateUrl: 'app/student/studentQuickNav/studentQuickNav.html'
        controller: 'StudentQuickNavCtrl'
        size: 'lg'
        resolve:
          otherCourses: ->
            Courses.filter((item)->
              item._id isnt $scope.course._id).slice(0,4)

      .result.then ->

    itemsPerPage: 5

    currentPage: 1

  $scope.loadCourse()
  $scope.loadLectures()

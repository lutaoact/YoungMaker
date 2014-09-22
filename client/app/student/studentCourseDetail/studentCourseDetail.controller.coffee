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
  $q
) ->

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
        $state.go 'student.home'

    loadLectures: ()->
      if $state.params.courseId
        Restangular.all('lectures').getList({courseId: $state.params.courseId})
        .then (lectures)->
          $scope.course.$lectures = lectures
          $scope.course.$lectures
      else
        $q([])

    loadProgress: ()->
      $scope.viewedLectureIndex = 1
      if $state.params.courseId
        Restangular.all('progresses').getList({courseId: $state.params.courseId})
        .then (progress)->
          progress?.forEach (lectureId)->
            viewedLecture = _.find $scope.course.$lectures, _id: lectureId
            viewedLecture?.$viewed = true
            $scope.viewedLectureIndex = $scope.course.$lectures.indexOf(viewedLecture) + 1 if $scope.viewedLectureIndex < $scope.course.$lectures.indexOf(viewedLecture) + 1
      else
        $q(null)

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

    gotoLecture: ()->
      if !$scope.course.$lectures?.length
        return
      viewedLectures = $scope.course.$lectures.filter (x)->
        x.$viewed
      if viewedLectures and viewedLectures.length > 0
        # GOTO that course
        # TODO: last viewed should not be the last viewed item :(
        lastViewed = viewedLectures[viewedLectures.length - 1]
        $state.go 'student.lectureDetail',
          courseId: $state.params.courseId
          lectureId: lastViewed._id

      else
        # Start from first lecture
        $state.go 'student.lectureDetail',
          courseId: $state.params.courseId
          lectureId: $scope.course.$lectures[0]._id

    itemsPerPage: 10

    currentPage: 1

  $scope.loadCourse()
  .then $scope.loadLectures
  .then $scope.loadProgress

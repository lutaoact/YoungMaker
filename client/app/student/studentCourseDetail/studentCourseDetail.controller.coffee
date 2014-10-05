'use strict'

angular.module('budweiserApp').controller 'StudentCourseDetailCtrl', (
  $q
  $scope
  $state
  Courses
  Category
  Restangular
) ->

  course = _.find Courses, _id:$state.params.courseId

  Category.find course.categoryId
  .then (category) ->
    course.$category = category

  angular.extend $scope,
    itemsPerPage: 10
    currentPage: 1
    course: course

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

  $scope.loadLectures()
  .then $scope.loadProgress

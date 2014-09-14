'use strict'

angular.module('budweiserApp').directive 'teacherCourseForm', ->
  restrict: 'EA'
  replace: true
  controller: 'TeacherCourseFormCtrl'
  templateUrl: 'app/teacher/teacherCourse/teacherCourseForm.html'
  scope:
    course: '='
    categories: '='

angular.module('budweiserApp').controller 'TeacherCourseFormCtrl', (
  $http
  $scope
  $state
  $upload
  fileUtils
  Restangular
) ->

  angular.extend $scope,

    deleteCourse: (course) ->
      course.remove().then ->
        $state.go('teacher.home')

    cancelCourse: ->
      $state.go('teacher.home')

    saveCourse: (course, form)->
      unless form.$valid then return
      if course._id?
        # update exists
        course.patch(
          name: course.name
          info: course.info
          categoryId: course.categoryId
        )
        .then (newCourse) ->
          course.__v = newCourse.__v
      else
        # create new
        Restangular.all('courses').post(course)
        .then (newCourse)->
          $state.go('teacher.course', courseId:newCourse._id)

    onThumbUploaded: (key) ->
      $scope.course.thumbnail = key
      $scope.course?.patch?(thumbnail: $scope.course.thumbnail)
      .then (newCourse) ->
        $scope.course.__v = newCourse.__v

angular.module('budweiserApp').controller 'TeacherCourseCtrl', (
  $http
  $scope
  $state
  $upload
  fileUtils
  Categories
  Restangular
) ->

  loadCourse = ->
    if $state.params.courseId is 'new'
      $scope.course = {}
    else
      Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        $scope.course = course

  angular.extend $scope,
    $state: $state
    categories: Categories
    course: undefined

    toggleLectures: ->
      stateName =
        if $state.includes('teacher.course.lectures')
          'teacher.course'
        else
          'teacher.course.lectures'
      $state.go(stateName, $state.params)

  loadCourse()

angular.module('budweiserApp').controller 'TeacherLecturesCtrl', (
  $http
  $scope
  $state
  $upload
  Classes
  Restangular
) ->

  loadCourse = ->
    if $state.params.courseId is 'new'
      $scope.course = {}
    else
      # load courses
      Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        $scope.course = course
        course.$classes = _.map(course.classes, (id) -> _.find(Classes, _id:id))
        Restangular.all('lectures').getList(courseId:course._id)
      .then (lectures) ->
        $scope.course.$lectures = _.map($scope.course.lectureAssembly, (id) -> _.find(lectures, _id:id))
        Restangular.one('progresses').get({courseId: $state.params.courseId})
      .then (result)->
        result

  angular.extend $scope,
    classes: Classes
    course: undefined

    deleteLecture: (lecture)->
      lecture.remove(courseId:$scope.course._id)
      .then ->
        lectures = $scope.course.$lectures
        lectures.splice(lectures.indexOf(lecture), 1)

    addClasse: (classe) ->
      classes = $scope.course.classes
      if !_.contains(classes, classe._id)
        $scope.course.patch classes: _.union(classes, [classe._id])
        .then (newCourse) ->
            $scope.course.classes = newCourse.classes
            $scope.course.$classes = _.map(newCourse.classes, (id) -> _.find(Classes, _id:id))

    removeClasse: (classe) ->
      classes = $scope.course.classes
      if _.contains(classes, classe._id)
        $scope.course.patch classes: _.without(classes, classe._id)
        .then (newCourse) ->
          $scope.course.classes = newCourse.classes
          $scope.course.$classes = _.map(newCourse.classes, (id) -> _.find(Classes, _id:id))

  $scope.$on 'ngrr-reordered', ->
    $scope.course.patch lectureAssembly:_.pluck($scope.course.$lectures, '_id')

  loadCourse()

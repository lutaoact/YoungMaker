'user strict'

angular.module('budweiserApp').directive 'teacherCourseLectures', ->
  restrict: 'EA'
  replace: true
  controller: 'TeacherCourseLecturesCtrl'
  templateUrl: 'app/teacher/teacherCourse/teacherCourseLectures.html'
  scope:
    course: '='
    classes: '='

angular.module('budweiserApp').controller 'TeacherCourseLecturesCtrl', (
  $http
  $scope
  Restangular
) ->

  angular.extend $scope,

    filter: (lecture, keyword) ->
      keyword = keyword ? ''
      name = lecture?.name ? ''
      content = lecture?.info ? ''
      text = _.str.clean(name + ' ' + content).toLowerCase()
      _.str.include(text, keyword)

    toggleLectures: (course) ->
      if !course._id? then return
      if course.$lectures?
        delete course.$lectures
        delete course.$progress
      else reloadLectures(course)

    getActiveClasse: ->
      _.find($scope.course.classes, $active:true)

    deleteLecture: (lecture)->
      lecture.remove(courseId:$scope.course._id)
      .then ->
        lectures = $scope.course.$lectures
        lectures.splice(lectures.indexOf(lecture), 1)

    addClasse: (classe) ->
      classeIds = _.pluck($scope.course.classes, '_id')
      if !_.contains(classeIds, classe._id)
        $scope.course.patch classes: _.union(classeIds, [classe._id])
        .then (newCourse) ->
          $scope.course.classes = newCourse.classes

    removeClasse: (classe) ->
      classeIds = _.pluck($scope.course.classes, '_id')
      if _.contains(classeIds, classe._id)
        $scope.course.patch classes:_.without(classeIds, classe._id)
        .then (newCourse) ->
          $scope.course.classes = newCourse.classes

  reloadLectures = (course) ->
    if !course._id? then return
    # load course
    Restangular.all('lectures').getList(courseId:course._id)
    .then (lectures) ->
      course.$lectures = lectures
    Restangular.one('progresses').get({courseId: course._id})
    .then (progress)->
      course.$progress = progress

  reloadLectures($scope.course) if $scope.course?.$lectures?

  $scope.$on 'ngrr-reordered', ->
    $scope.course.patch lectureAssembly:_.pluck($scope.course.$lectures, '_id')

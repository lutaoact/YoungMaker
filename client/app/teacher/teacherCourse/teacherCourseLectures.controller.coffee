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
      else
        # load course
        Restangular.all('lectures').getList(courseId:course._id)
        .then (lectures) ->
          course.$lectures = _.map(course.lectureAssembly, (id) -> _.find(lectures, _id:id))
        Restangular.one('progresses').get({courseId: course._id})
        .then (progress)->
          course.$progress = progress

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

    removeClasse: (classe) ->
      classes = $scope.course.classes
      if _.contains(classes, classe._id)
        $scope.course.patch classes: _.without(classes, classe._id)
        .then (newCourse) ->
          $scope.course.classes = newCourse.classes

  $scope.$on 'ngrr-reordered', (event, data) ->
    $scope.course.patch lectureAssembly:_.pluck($scope.course.$lectures, '_id')

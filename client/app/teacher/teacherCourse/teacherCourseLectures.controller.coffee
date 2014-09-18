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
  $state
  $modal
  $document
  Restangular
) ->

  angular.extend $scope,

    progressMap: {}
    activeProgressKey: undefined

    filter: (lecture, keyword) ->
      keyword = keyword ? ''
      name = lecture?.name ? ''
      content = lecture?.info ? ''
      text = _.str.clean(name + ' ' + content).toLowerCase()
      _.str.include(text, keyword)

    toggleLectures: (course) ->
      if !course._id? then return
      targetElementId =
        if course.$lectures?
          delete course.$lectures
          'course-' + course._id
        else
          reloadLectures(course)
          'lectures-' + course._id
      targetElement = angular.element(document.getElementById(targetElementId))
      $document.scrollToElement(targetElement, 60, 500)

    startTeaching: (course, lecture) ->
      classe = _.find(course.classes, $active:true)
      $state.go 'teacher.teaching',
        courseId: course._id
        classeId: classe._id
        lectureId: lecture._id

    selectClasse: (classe) ->
      $scope.activeProgressKey = classe._id
      if $scope.progressMap.hasOwnProperty(classe._id) then return
      Restangular.all('progresses').getList({courseId: $scope.course._id, classeId: classe._id})
      .then (progress) ->
        $scope.progressMap[classe._id] = progress

    deleteLecture: (lecture) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除课时'
          message: -> """确认要删除《#{$scope.course.name}》中的"#{lecture.name}"吗？"""
      .result.then ->
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

  reloadLectures($scope.course) if $scope.course?.$lectures?

  $scope.$on 'ngrr-reordered', ->
    $scope.course.patch lectureAssembly:_.pluck($scope.course.$lectures, '_id')

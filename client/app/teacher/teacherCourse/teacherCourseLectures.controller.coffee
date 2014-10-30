'user strict'

angular.module('mauiApp').directive 'teacherCourseLectures', ->
  restrict: 'EA'
  replace: true
  controller: 'TeacherCourseLecturesCtrl'
  templateUrl: 'app/teacher/teacherCourse/teacherCourseLectures.html'
  scope:
    course: '='
    classes: '='

angular.module('mauiApp').controller 'TeacherCourseLecturesCtrl', (
  $scope
  $state
  $modal
  $rootScope
  Restangular
) ->

  angular.extend $scope,

    progressMap: {}
    activeProgressKey: null
    firstUndoLecture: null

    filter: (lecture, keyword) ->
      keyword = keyword ? ''
      name = lecture?.name ? ''
      content = lecture?.info ? ''
      text = _.str.clean(name + ' ' + content).toLowerCase()
      _.str.include(text, keyword)

    startTeaching: (course, lecture) ->
      classe = _.find(course.classes, $active:true)
      $state.go 'teacher.teaching',
        courseId: course._id
        classeId: classe._id
        lectureId: lecture._id

    selectClasse: (classe) ->
      if !classe.$active then return
      $scope.activeProgressKey = classe._id
      if $scope.progressMap[$scope.activeProgressKey]?
        setFirstUndoLecture()
      else
        Restangular.all('progresses').getList({courseId: $scope.course._id, classeId: classe._id})
        .then (progress) ->
          $scope.progressMap[classe._id] = progress
          setFirstUndoLecture()

    createLecture: ->
      $scope.creating = true
      lecture =
        name: "新建课时 #{$scope.course.lectureAssembly.length + 1}"
        slides:[]
        keyPoints: []
        homeworks:[]
        quizzes:[]
      Restangular.all('lectures').post(lecture, courseId:$scope.course._id)
      .then (newLecture) ->
        $scope.creating = false
        $state.go('teacher.lecture', courseId: $scope.course._id, lectureId: newLecture._id)

    deleteLecture: (lecture) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除课时'
          message: -> """确认要删除《#{$scope.course.name}》中的"#{lecture.name}"？"""
      .result.then ->
        lecture.remove(courseId:$scope.course._id)
        .then ->
          lectures = $scope.course.$lectures
          lectures.splice(lectures.indexOf(lecture), 1)
          setFirstUndoLecture()

    sortLecture: ->
      $scope.course.patch lectureAssembly:_.pluck($scope.course.$lectures, '_id')

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

  setFirstUndoLecture = ->
    progress = $scope.progressMap[$scope.activeProgressKey]
    $scope.firstUndoLecture = _.find($scope.course.$lectures, (l) -> progress.indexOf(l._id) == -1)

  reloadLectures($scope.course)

angular.module('mauiApp')

.controller 'CourseEditorCtrl', (
  Auth
  $scope
  $state
  Restangular
  CurrentUser
  notify
) ->

  angular.extend $scope,
    article: {}

    editingTitle: !$state.params.courseId

    course:
      content: ''
      steps: []

    categories: [
      {
        id: '1'
        name: '物理'
      }
      {
        id: '2'
        name: '化学'
      }
      {
        id: '3'
        name: '数学'
      }
    ]

    saveCourse: (form, isTitle) ->
      if !form.$valid then return
      Restangular.all('courses').post($scope.course)
      .then (course)->
        if isTitle
          $scope.editingTitle = false
        angular.extend $scope.course, course
      .catch (error) ->
        console.log 'error', error

    if $state.params.courseId
      Restangular.one('courses', $state.params.courseId).get()
      .then (course)->
        angular.extend $scope.course, course


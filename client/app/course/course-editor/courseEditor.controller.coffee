angular.module('mauiApp')

.controller 'CourseEditorCtrl', (
  Auth
  $scope
  $state
  Restangular
  CurrentUser
  notify
  $sanitize
) ->

  angular.extend $scope,
    viewState:
      showPreview: false

    course:
      content: ''

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


    submitCourse: (form)->
      if !form.$valid then return
      $scope.saveCourse()

    saveCourse: () ->
      # compile content todo: may not need this. Client can decide how to display according to steps
      $scope.course.content = $sanitize($('.preview').html()).replace /(ng-binding|ng-scope)/g, ''
      # get the first image. todo: move to server side
      if !$scope.course.image
        firstImage = $('.preview img')
        if firstImage?.length
          $scope.course.image = firstImage.attr('src')
      if !$scope.course._id
        Restangular.all('courses').post($scope.course)
        .then (course)->
          $state.go 'courseEditor', {courseId: course._id}
        .catch (error) ->
          console.log 'error', error
      else
        console.log $scope.course
        $scope.course.put()
        .then (course)->
          angular.extend $scope.course, course
        .catch (error) ->
          console.log 'error', error

    addStep: ()->
      $scope.course.steps.push {}

  if $state.params.courseId
    Restangular.one('courses', $state.params.courseId).get()
    .then (course)->
      $scope.course = course
  else
    $scope.course.steps = [{}]


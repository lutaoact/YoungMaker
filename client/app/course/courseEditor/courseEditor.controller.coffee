angular.module('mauiApp')

.controller 'CourseEditorCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
  $sanitize
  $location
  $anchorScroll
  $filter
) ->

  angular.extend $scope,
    viewState:
      showPreview: false
      lastPlugin: undefined

    plugins: [
        text: 'Html'
        type: 'wysiwyg'
      ,
        text: 'Markdown'
        type: 'md'
      ,
        text: 'embed'
        type: 'embed'
    ]

    course:
      content: ''

    submitCourse: (form)->
      $scope.submitted = true
      if !form.$valid then return
      $scope.saveCourse()

    saveCourse: () ->
      # compile content todo: may not need this. Client can decide how to display according to steps
      $scope.course.content = ''
      $scope.course.steps.forEach (step)->
        $scope.course.content += """<h2>#{step.title}</h2>"""
        switch step.type
          when 'wysiwyg'
            $scope.course.content += $sanitize(step.content).replace /(ng-binding|ng-scope)/g, ''
          when 'embed'
            $scope.course.content += $filter('embed')(step.content)
          when 'md'
            $scope.course.content += $filter('showdown')(step.content)
        $scope.course.content += """<hr/>"""

      # get the first image. todo: move to server side
      if !$scope.course.image
        firstImage = $('.preview img:not(.emoji)')
        if firstImage?.length
          $scope.course.image = firstImage.attr('src')
      if !$scope.course._id
        Restangular.all('courses').post($scope.course)
        .then (course)->
          $state.go 'courseEditor', {courseId: course._id}
        .catch (error) ->
          console.log 'error', error
      else
        $scope.course.put()
        .then (course)->
          angular.extend $scope.course, course
        .catch (error) ->
          console.log 'error', error

    addStep: (plugin)->
      @viewState.lastPlugin = plugin
      switch plugin.type
        when 'wysiwyg'
          $scope.course.steps.push {type:plugin.type}
        when 'embed'
          $scope.course.steps.push (type:plugin.type)
        when 'md'
          $scope.course.steps.push (type:plugin.type)
        else
          $scope.course.steps.push {type:'wysiwyg'}
      $location.hash('bottom')
      # call $anchorScroll()
      $anchorScroll()

  $scope.viewState.lastPlugin = $scope.plugins[0]

  if $state.params.courseId
    Restangular.one('courses', $state.params.courseId).get()
    .then (course)->
      $scope.course = course
  else
    $scope.course.steps = [{type:plugin.type}]

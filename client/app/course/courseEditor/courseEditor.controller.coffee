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
  $q
  $timeout
  messageModal
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
      ,
        text: 'code'
        type: 'code'
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
      $scope.course.steps.forEach (step, index)->
        stepId = 'step' + (index + 1).toString()
        $scope.course.content += """<h2 class="step-title" id="#{stepId}">#{step.title}</h2>"""
        switch step.type
          when 'wysiwyg'
            $scope.course.content += $sanitize(step.content).replace /(ng-binding|ng-scope)/g, ''
          when 'embed'
            $scope.course.content += $filter('embed')(step.content)
          when 'md'
            $scope.course.content += $filter('showdown')(step.content)
          when 'code'
            $scope.course.content += $filter('code')(step.content)
        $scope.course.content += """<hr/>"""

      # get the first image. todo: move to server side
      if !$scope.course.image
        images = $filter('images')($scope.course.content)
        $scope.course.image = images[0]?.src
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
          notify
            message: '已保存'
            classes: 'alert-success'
        .catch (error) ->
          console.log 'error', error

    addStep: (plugin, index)->
      @viewState.lastPlugin = plugin
      index = $scope.course.steps.length - 1 if index is undefined
      $scope.course.steps.splice index+1, 0, {title:'请输入标题', type:plugin.type}

    aceOption:
      useWrapMode : true
      showGutter: true

    onCoverUploaded: ($data)->
      $scope.course.image = $data

    cancelSave: ()->
      messageModal.open
        title: -> '取消保存'
        message: -> '您的改动会被清除，是否取消保存？'
      .result.then ->
        # todo should go back
        $state.go 'courseList'

    removeStep: (step)->
      messageModal.open
        title: -> '删除步骤'
        message: -> "您是否要删除该步骤“#{step.title}”"
      .result.then ->
        # todo should go back
        $scope.course.steps.splice ($scope.course.steps.indexOf step), 1

    moveUpStep: (step)->
      index = $scope.course.steps.indexOf step
      $scope.course.steps.splice index, 1
      $scope.course.steps.splice index-1, 0, step

    moveDownStep: (step)->
      index = $scope.course.steps.indexOf step
      $scope.course.steps.splice index, 1
      $scope.course.steps.splice index+1, 0, step

  $scope.viewState.lastPlugin = $scope.plugins[0]

  $q (resolve, reject)->
    if $state.params.courseId
      Restangular.one('courses', $state.params.courseId).get()
      .then (course)->
        $scope.course = course
        resolve $scope.course
    else
      $scope.course.steps = [{title:'第一步',type:$scope.viewState.lastPlugin.type}]
      resolve $scope.course
  .then (course)->
    Restangular.all('categories').getList()
  .then (categories) ->
    $scope.categories = categories
    if $scope.course.categoryId
      $scope.course.$category = _.find $scope.categories, (category)->
        category._id is $scope.course.categoryId._id
    else
      $scope.course.categoryId = $scope.categories[0]


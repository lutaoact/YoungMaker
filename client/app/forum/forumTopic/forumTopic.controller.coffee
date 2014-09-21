'use strict'

angular.module('budweiserApp').controller 'ForumTopicCtrl',
(
  $scope
  Restangular
  notify
  $state
  $q
  $modal
  CurrentUser
  focus
  $timeout
  textAngularManager
  $rootScope
) ->

  if not $state.params.courseId or not $state.params.topicId
    return

  $rootScope.additionalMenu = [
    {
      title: '主页'
      link: 'student.courseList'
      role: 'student'
    }
    {
      title: '主页'
      link: 'teacher.home'
      role: 'teacher'
    }
    {
      title: '课程主页<i class="fa fa-home"></i>'
      link: "student.courseDetail({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '课程主页<i class="fa fa-home"></i>'
      link: "teacher.courseDetail({courseId:'#{$state.params.courseId}'})"
      role: 'teacher'
    }
    {
      title: '讨论<i class="fa fa-comments-o"></i>'
      link: "forum.course({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '统计<i class="fa fa-bar-chart-o"></i>'
      link: "student.courseStats({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '统计<i class="fa fa-bar-chart-o"></i>'
      link: "teacher.courseStats({courseId:'#{$state.params.courseId}'})"
      role: 'teacher'
    }
  ]

  $scope.$on '$destroy', ()->
    $rootScope.additionalMenu = []
    $rootScope.navInSub = false

  $rootScope.navInSub = true

  editorScope = undefined

  angular.extend $scope,
    loading: true

    topic: null

    me: CurrentUser

    stateParams: $state.params

    loadTopic: ()->
      Restangular.one('dis_topics', $state.params.topicId).get()
      .then (topic)->
        $scope.topic = topic
        Restangular.all('dis_replies').getList({disTopicId: $state.params.topicId})
      .then (replies)->
        replies.forEach (reply)->
        $scope.topic.$replies = replies

    recommendedTopics: undefined

    loadRecommendedTopics: ()->
      Restangular.all('dis_topics').getList(courseId: $state.params.courseId)
      .then (dis_topics)->
        $scope.recommendedTopics = dis_topics.slice 0,3

  $q.all [
    $scope.loadTopic()
    $scope.loadRecommendedTopics()
  ]
  .then ()->
    $scope.loading = false

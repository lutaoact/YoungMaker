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

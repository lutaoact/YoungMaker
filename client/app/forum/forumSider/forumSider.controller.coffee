'use strict'

angular.module('budweiserApp').controller 'ForumSiderCtrl',
(
  $scope
  Restangular
  notify
  $state
  $q
  $rootScope
  $window
  $timeout
  $modal
  Auth
  Tag
  $filter
) ->

  if not $state.params.courseId
    return
  angular.extend $scope,
    loading: true

    topics: null

    currentTopic: undefined

    lectureId: $state.params.lectureId

    loadTopics: ()->
      Restangular.all('dis_topics').getList({courseId: $state.params.courseId})
      .then (topics)->
        # pull out the tags in content
        topics.forEach (topic)->
          topic.$tags = (Tag.genTags topic.content)
        $scope.topics = $filter('filter')(topics, $state.params.lectureId)

    viewTopic: (topic)->
      $scope.currentTopic = undefined
      $scope.showTopic = true
      Restangular.one('dis_topics', topic._id).get()
      .then (topic)->
        $scope.currentTopic = topic
        Restangular.all('dis_replies').getList({disTopicId: topic._id})
      .then (replies)->
        replies.forEach (reply)->
        $scope.currentTopic.$replies = replies

    backToList: ()->
      $scope.currentTopic = undefined
      $scope.showTopic = false

  $q.all [
    $scope.loadTopics()
  ]
  .then ()->
    $scope.loading = false



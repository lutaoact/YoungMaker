'use strict'

angular.module('budweiserApp').controller 'ForumSiderCtrl',
(
  $scope
  Restangular
  notify
  $state
  $q
  $rootScope
  $document
  $window
  $timeout
  $modal
  Auth
) ->

  if not $state.params.courseId
    return
  angular.extend $scope,
    loading: true

    course: null

    topics: null

    currentTopic: undefined

    imagesToInsert: undefined

    loadCourse: ()->
      Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        Restangular.all('key_points').getList(categoryId: course.categoryId)
        .then (keypoints)->
          $scope.keypoints = keypoints
        $scope.course = course

    loadLectures: ()->
      Restangular.all('lectures').getList({courseId: $state.params.courseId})
      .then (lectures)->
        $scope.course.$lectures = lectures


    loadTopics: ()->
      Restangular.all('dis_topics').getList({courseId: $state.params.courseId})
      .then (topics)->
        # pull out the tags in content
        topics.forEach (topic)->
          topic.$tags = (topic.content.match /<div\s+class="tag\W.*?<\/div>/)?.join()
        $scope.topics = topics

    createTopic: ()->
      # validate
      $modal.open
        templateUrl: 'app/forum/discussionComposerPopup/discussionComposerPopup.html'
        controller: 'DiscussionComposerPopupCtrl'
        resolve:
          keypoints: -> $scope.keypoints
          course: -> $scope.course
          lectures: -> $scope.course.$lectures
          topics: -> $scope.topics
      .result.then (dis_topic)->
        $scope.topics.splice 0, 0, dis_topic

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
    $scope.loadCourse().then $scope.loadLectures
    $scope.loadTopics()
  ]
  .then ()->
    $scope.loading = false



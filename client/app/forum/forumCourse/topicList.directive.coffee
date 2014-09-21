'use strict'

angular.module('budweiserApp')

.directive 'topicList', ->
  restrict: 'E'
  replace: true
  controller: 'TopicListCtrl'
  templateUrl: 'app/forum/forumCourse/topicList.template.html'
  scope:
    topics: '='
    onTopicClick: '&'
    onTagClick: '&'

.controller 'TopicListCtrl', ($scope, Auth, $modal, Restangular, $state, Tag)->
  angular.extend $scope,
    selectTopic: (topic)->
      $scope.selectedTopic = topic
      $scope.onTopicClick()?(topic)

    me: Auth.getCurrentUser()

    loadCourse: ()->
      Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        Restangular.all('key_points').getList(categoryId: course.categoryId)
        .then (keypoints)->
          $scope.keypoints = keypoints

        Restangular.all('lectures').getList(courseId: course._id)
        .then (lectures) ->
          $scope.lectures = lectures

        $scope.course = course

    topicsFilter: (item)->
      switch $scope.viewState.filterMethod
        when 'all'
          return true
        when 'createdByMe'
          return item.postBy._id is $scope.me._id
      return true

    deleteTopic: (topic)->
      topic.remove()
      .then ()->
        $scope.topics.splice $scope.topics.indexOf(topic), 1

    createTopic: ()->
      # validate
      $modal.open
        templateUrl: 'app/forum/discussionComposerPopup/discussionComposerPopup.html'
        controller: 'DiscussionComposerPopupCtrl'
        resolve:
          keypoints: -> $scope.keypoints
          topics: -> $scope.topics
          course: -> $scope.course
          lectures: -> $scope.lectures

      .result.then (dis_topic)->
        dis_topic.$tags = (Tag.genTags dis_topic.content)
        dis_topic.$heat = 1000 / (moment().diff(moment(dis_topic.created),'hours') + 1)+ dis_topic.repliesNum * 10 + dis_topic.voteUpUsers.length * 10
        $scope.topics.splice 0, 0, dis_topic

  $scope.loadCourse()


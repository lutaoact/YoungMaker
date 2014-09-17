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

.controller 'TopicListCtrl', ($scope)->
  angular.extend $scope,
    selectTopic: (topic)->
      $scope.selectedTopic = topic
      $scope.onTopicClick()?(topic)

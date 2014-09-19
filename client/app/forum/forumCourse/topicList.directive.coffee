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

.controller 'TopicListCtrl', ($scope, Auth)->
  angular.extend $scope,
    selectTopic: (topic)->
      $scope.selectedTopic = topic
      $scope.onTopicClick()?(topic)

    me: Auth.getCurrentUser()

    topicsFilter: (item)->
      switch $scope.viewState.filterMethod
        when 'all'
          return true
        when 'createdByMe'
          return item.postBy._id is $scope.me._id
      return true


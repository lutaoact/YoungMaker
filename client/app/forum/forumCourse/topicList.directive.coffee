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
    lectureId: '@'

.controller 'TopicListCtrl', ($scope, Auth, $modal, Restangular, $state, Tag)->
  angular.extend $scope,
    selectTopic: (topic)->
      $scope.selectedTopic = topic
      $scope.onTopicClick()?(topic)

    me: Auth.getCurrentUser()

    queryTags: undefined

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

    deleteTopic: (topic, $event)->
      $event?.stopPropagation()
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除帖子'
          message: -> "是否要删除您的帖子：\"#{topic.title}\"，删除后将无法恢复！"
      .result.then ->
        topic.remove()
        .then ()->
          $scope.topics.splice $scope.topics.indexOf(topic), 1

    filterTags: []

    searchByTag: (tag)->
      if $scope.filterTags.indexOf(tag) > -1
        $scope.filterTags.splice $scope.filterTags.indexOf(tag), 1
        tag.$active = false
      else
        $scope.filterTags.push tag
        tag.$active = true

    filterByTags: (item)->
      $scope.filterTags.every (tag)->
        item.content.indexOf(tag.name) > -1

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
          lectureId: -> $scope.lectureId
        backdrop: 'static'
        keyboard: false

      .result.then (dis_topic)->
        dis_topic.$tags = (Tag.genTags dis_topic.content)
        dis_topic.$heat = 1000 / (moment().diff(moment(dis_topic.created),'hours') + 1)+ dis_topic.repliesNum * 10 + dis_topic.voteUpUsers.length * 10
        $scope.topics.splice 0, 0, dis_topic

  $scope.$watch 'topics', (value)->
    # pull out the tags in content
    if value?.length
      $scope.queryTags = []
      $scope.topics.forEach (topic)->
        $scope.queryTags = $scope.queryTags.concat topic.metadata?.tags
        topic.$tags = (Tag.genTags topic.content)
        topic.$heat = 1000 / (moment().diff(moment(topic.created),'hours') + 1)+ topic.repliesNum * 10 + topic.voteUpUsers.length * 10
      $scope.queryTags = _.compact $scope.queryTags
      $scope.queryTags = _.uniq $scope.queryTags, (x)-> x.srcId

  $scope.loadCourse()


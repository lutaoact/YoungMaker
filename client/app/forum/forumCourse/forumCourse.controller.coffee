'use strict'

angular.module('budweiserApp').controller 'ForumCourseCtrl',
(
  $scope
  Restangular
  notify
  $state
  $q
) ->

  if not $state.params.courseId
    return
  angular.extend $scope,
    loading: true

    course: null

    topics: null

    myTopic: null

    posting: false

    loadCourse: ()->
      Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        $scope.course = course

    loadLectures: ()->
      Restangular.all('lectures').getList({courseId: $state.params.courseId})
      .then (lectures)->
        $scope.course.$lectures = lectures


    loadTopics: ()->
      Restangular.all('dis_topics').getList({courseId: $state.params.courseId})
      .then (topics)->
        $scope.topics = topics

    initTopic: ()->
      @myTopic = {} if !@myTopic
      @myTopic.content = undefined
      @myTopic.title = undefined
      @myTopic.lectureId = undefined

    createTopic: ()->
      # validate

      @posting = true
      @topics.post @myTopic, {courseId: $state.params.courseId}
      .then (dis_topic)->
        $scope.topics.get(dis_topic._id)
      .then (dis_topic)->
        $scope.topics.push dis_topic
        $scope.initTopic()
        $scope.posting = false

  $q.all [
    $scope.loadCourse()
    $scope.loadLectures()
    $scope.loadTopics()
  ]
  .then ()->
    $scope.loading = false



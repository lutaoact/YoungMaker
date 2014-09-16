'use strict'

angular.module('budweiserApp').controller 'ForumCourseCtrl',
(
  $scope
  Restangular
  notify
  $state
  $q
  $rootScope
  $sce
  $document
  $window
  $timeout
  CurrentUser
) ->

  $rootScope.additionalMenu = [
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


  if not $state.params.courseId
    return
  angular.extend $scope,
    loading: true

    course: null

    topics: null

    myTopic: null

    posting: false

    me: CurrentUser

    selectedTopic: undefined

    imagesToInsert: undefined

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
        console.log topics
        $scope.topics = topics
        $scope.viewTopic(topics[0]) if topics[0]

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

    viewTopic: (topic)->
      $scope.selectedTopic = undefined
      Restangular.one('dis_topics', topic._id).get()
      .then (topic)->
        topic.$safeContent = $sce.trustAsHtml topic.content
        $scope.selectedTopic = topic
        Restangular.all('dis_replies').getList({disTopicId: topic._id})
      .then (replies)->
        replies.forEach (reply)->
          reply.$safeContent = $sce.trustAsHtml reply.content
        $scope.selectedTopic.$replies = replies
        $document.scrollTop(340)

    clientHeight: undefined

    onImgUploaded: (key)->
      @imagesToInsert ?= []
      @imagesToInsert.push
        url: "/api/assets/images/#{key}"
        key: key

    newReply: {}
    replying: false

    replyTo: (topic, reply)->
      # validate
      @replying = true
      @imagesToInsert?.forEach (image)->
        reply.content += "<img class=\"sm\" src=\"#{image.url}\">"
      topic.$replies.post reply, {disTopicId: topic._id}
      .then (dis_reply)->
        dis_reply.$safeContent = $sce.trustAsHtml dis_reply.content
        topic.$replies.splice 0, 0, dis_reply
        $scope.initMyReply()
        $scope.replying = false
        $scope.imagesToInsert = undefined

    initMyReply: ()->
      @newReply = {} if !@newReply
      @newReply.content = ''

    toggleVote: (reply)->
      reply.one('vote').post()
      .then (res)->
        reply.voteUpUsers = res.voteUpUsers

  setclientHeight = ()->
    $scope.clientHeight =
      "min-height": $window.innerHeight

  setclientHeight()

  handle = angular.element($window).bind 'resize', setclientHeight

  $scope.$on '$destroy', ->
    angular.element($window).unbind 'resize', setclientHeight

  $q.all [
    $scope.loadCourse().then $scope.loadLectures
    $scope.loadTopics()
  ]
  .then ()->
    $scope.loading = false



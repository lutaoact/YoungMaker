'use strict'

angular.module('budweiserApp').controller 'ForumCourseCtrl',
(
  $scope
  Restangular
  notify
  $state
  $q
  $rootScope
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



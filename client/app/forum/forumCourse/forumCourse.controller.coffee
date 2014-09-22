'use strict'

angular.module('budweiserApp').controller 'ForumCourseCtrl',
(
  $scope
  Restangular
  notify
  $state
  $q
  $rootScope
  $window
  $timeout
  CurrentUser
  $modal
  AllKeypoints
  Tag
) ->
  $rootScope.additionalMenu = [
    {
      title: '主页'
      link: 'student.courseList'
      role: 'student'
    }
    {
      title: '主页'
      link: 'teacher.home'
      role: 'teacher'
    }
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
    $rootScope.navInSub = false

  $rootScope.navInSub = true

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
        $scope.keypoints = AllKeypoints.filter (x) -> x._id is course.categoryId
        $scope.course = course

    loadLectures: ()->
      Restangular.all('lectures').getList({courseId: $state.params.courseId})
      .then (lectures)->
        $scope.course.$lectures = lectures


    loadTopics: ()->
      Restangular.all('dis_topics').getList({courseId: $state.params.courseId})
      .then (topics)->
        # pull out the tags in content
        $scope.queryTags = []
        topics.forEach (topic)->
          $scope.queryTags = $scope.queryTags.concat topic.metadata?.tags
          topic.$tags = (Tag.genTags topic.content)
          topic.$heat = 1000 / (moment().diff(moment(topic.created),'hours') + 1)+ topic.repliesNum * 10 + topic.voteUpUsers.length * 10
        $scope.queryTags = _.compact $scope.queryTags
        $scope.queryTags = _.uniq $scope.queryTags, (x)-> x.srcId
        $scope.topics = topics

    viewTopic: (topic)->
      $state.go 'forum.topic',
        courseId: $scope.course._id
        topicId: topic._id

    searchByTag: (tag)->
      console.log tag


    queryTags: undefined

  $q.all [
    $scope.loadCourse().then $scope.loadLectures
    $scope.loadTopics()
  ]
  .then ()->
    $scope.loading = false



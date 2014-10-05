'use strict'

angular.module('budweiserApp').controller 'ForumCourseCtrl', (
  $q
  Tag
  $scope
  $state
  Navbar
  CurrentUser
  Restangular
  AllKeypoints
) ->

  if !$state.params.courseId then return

  angular.extend $scope,
    me: CurrentUser
    course: null
    topics: null
    myTopic: null
    loading: true
    posting: false
    queryTags: undefined
    selectedTopic: undefined
    imagesToInsert: undefined

    loadCourse: ()->
      Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        $scope.keypoints = AllKeypoints.filter (x) -> x._id is course.categoryId
        $scope.course = course
        Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"

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
      $scope.$broadcast 'topics.query', tag

  $scope.$on '$destroy', Navbar.resetTitle

  $q.all [
    $scope.loadCourse().then $scope.loadLectures
    $scope.loadTopics()
  ]
  .then ()->
    $scope.loading = false



'use strict'

angular.module('budweiserApp').controller 'ForumCourseCtrl', (
  $q
  Tag
  $scope
  $state
  Navbar
  Courses
  CurrentUser
  Restangular
  AllKeypoints
) ->

  if !$state.params.courseId then return

  course = _.find Courses, _id:$state.params.courseId
  $scope.$on '$destroy', Navbar.resetTitle
  Navbar.setTitle course.name,
    if CurrentUser?.role == 'teacher'
       "teacher.course({courseId:'#{$state.params.courseId}'})"
    else
       "student.courseDetail({courseId:'#{$state.params.courseId}'})"

  angular.extend $scope,
    me: CurrentUser
    course: course
    topics: null
    myTopic: null
    loading: true
    posting: false
    queryTags: undefined
    selectedTopic: undefined
    imagesToInsert: undefined

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

  $q.all [
    $scope.loadLectures()
    $scope.loadTopics()
  ]
  .then ()->
    $scope.loading = false


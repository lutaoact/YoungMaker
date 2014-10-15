'use strict'

angular.module('budweiserApp').controller 'DiscussionComposerPopupCtrl',
(
  $scope
  $modalInstance
  keypoints
  course
  lectures
  topics
  lectureId
  $modal
) ->

  angular.extend $scope,

    lectures: lectures

    keypoints: keypoints

    lectureId: lectureId

    close: ->
      if @myTopic.title or @myTopic.content
        $modal.open
          templateUrl: 'components/modal/messageModal.html'
          controller: 'MessageModalCtrl'
          resolve:
            title: -> '警告!'
            message: -> "是否放弃编辑？"
        .result.then ->
          $modalInstance.dismiss('close')
      else
        $modalInstance.dismiss('close')


    myTopic:
      metadata:
        postType: '提问'

    create: ()->
      topics.post @myTopic, {courseId: course._id}
      .then (dis_topic)->
        $scope.imagesToInsert = undefined
        $modalInstance.close dis_topic

    viewState: {}

    addLectureAsTag: (lecture)->
      $scope.myTopic.metadata ?= {}
      $scope.myTopic.metadata.tags ?= []
      hasTag = $scope.myTopic.metadata.tags.some (tag)-> tag.srcId is lecture._id
      if hasTag
        return
      else
        $scope.myTopic.metadata.tags.push
          type: 'lecture'
          srcId: lecture._id
          name: lecture.name

    addKeypointAsTag: (keypoint)->
      $scope.myTopic.metadata ?= {}
      $scope.myTopic.metadata.tags ?= []
      hasTag = $scope.myTopic.metadata.tags.some (tag)-> tag.srcId is keypoint._id
      if hasTag
        return
      else
        $scope.myTopic.metadata.tags.push
          type: 'keypoint'
          srcId: keypoint._id
          name: keypoint.name

    deleteTag: (tag)->
      $scope.myTopic.metadata.tags.splice $scope.myTopic.metadata.tags.indexOf(tag), 1

  if lectureId
    $scope.viewState.$lecture = ($scope.lectures.filter (lecture)->
      lecture._id is lectureId
    )[0]
    $scope.addLectureAsTag($scope.viewState.$lecture)




'use strict'

angular.module('budweiserApp').controller 'DiscussionComposerPopupCtrl',
(
  $scope
  $modalInstance
  keypoints
  course
  lectures
  topics
) ->

  angular.extend $scope,

    lectures: lectures

    keypoints: keypoints

    close: ->
      $modalInstance.dismiss('close')

    myTopic: {}

    create: ()->
      @myTopic.metadata ?= {}
      @myTopic.metadata.postType = 'question'
      topics.post @myTopic, {courseId: course._id}
      .then (dis_topic)->
        $scope.imagesToInsert = undefined
        $modalInstance.close dis_topic

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


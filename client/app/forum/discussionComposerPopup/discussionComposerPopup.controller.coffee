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
      topics.post @myTopic, {courseId: course._id}
      .then (dis_topic)->
        $scope.imagesToInsert = undefined
        $modalInstance.close dis_topic

    $tag: {}

  $scope.$watch '$tag', ->
    console.log 'watch'
    if $scope.$tag.lecture
      $scope.myTopic.metadata ?= {}
      $scope.myTopic.metadata.tags ?= []
      hasTag = $scope.myTopic.metadata.tags.some (tag)-> tag.srcId is $scope.$tag.lecture._id
      if hasTag
        return
      else
        $scope.myTopic.metadata.tags.push
          type: 'lecture'
          srcId: $scope.$tag.lecture._id
          name: $scope.$tag.lecture.name
    if $scope.$tag.keypoint
      $scope.myTopic.metadata ?= {}
      $scope.myTopic.metadata.tags ?= []
      hasTag = $scope.myTopic.metadata.tags.some (tag)-> tag.srcId is $scope.$tag.keypoint._id
      if hasTag
        return
      else
        $scope.myTopic.metadata.tags.push
          type: 'keypoint'
          srcId: $scope.$tag.keypoint._id
          name: $scope.$tag.keypoint.name
  , true





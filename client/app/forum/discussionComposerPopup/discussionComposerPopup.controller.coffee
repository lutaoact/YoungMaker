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
      @imagesToInsert?.forEach (image)->
        $scope.myTopic.content += "<img class=\"sm image-zoom\" src=\"#{image.url}\">"
      if @myTopic.$lecture or @myTopic.$keypoint
        @myTopic.content = '<br/>' + @myTopic.content
      if @myTopic.$lecture
        @myTopic.lectureId = @myTopic.$lecture._id
        @myTopic.content = "<div class=\"tag\" href=\"lecture\" src=\"#{$scope.myTopic.$lecture._id}\">#{$scope.myTopic.$lecture.name}</div>" + @myTopic.content
      if @myTopic.$keypoint
        @myTopic.content = "<div class=\"tag\" href=\"keypoint\" src=\"#{$scope.myTopic.$keypoint._id}\">#{$scope.myTopic.$keypoint.name}</div>" + @myTopic.content
      topics.post @myTopic, {courseId: course._id}
      .then (dis_topic)->
        $scope.imagesToInsert = undefined
        console.log dis_topic
        $modalInstance.close dis_topic

    imagesToInsert: undefined

    onImgUploaded: (key)->
      @imagesToInsert ?= []
      @imagesToInsert.push
        url: "/api/assets/images/#{key}-blog" # -blog means the image will be compressed
        key: key



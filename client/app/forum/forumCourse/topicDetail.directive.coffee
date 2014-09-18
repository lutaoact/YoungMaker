'use strict'

angular.module('budweiserApp')

.directive 'topicDetail', ->
  restrict: 'E'
  replace: true
  controller: 'TopicDetailCtrl'
  templateUrl: 'app/forum/forumCourse/topicDetail.template.html'
  scope:
    topic: '='

.controller 'TopicDetailCtrl', ($scope, Auth, Restangular)->
  angular.extend $scope,

    me: Auth.getCurrentUser()

    imagesToInsert: undefined
    onImgUploaded: (key)->
      @imagesToInsert ?= []
      @imagesToInsert.push
        url: "/api/assets/images/#{key}-blog"
        key: key

    newReply: {}
    replying: false

    replyTo: (topic, reply)->
      # validate
      @replying = true
      reply.content = reply.content.replace /\r?\n/g, '<br/>'
      @imagesToInsert?.forEach (image)->
        reply.content += "<img class=\"sm image-zoom\" src=\"#{image.url}\">"
      topic.$replies.post reply, {disTopicId: topic._id}
      .then (dis_reply)->
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

    deleteReply: (topic, reply)->
      reply.remove()
      .then ()->
        topic.$replies.splice topic.$replies.indexOf(reply), 1



'use strict'

angular.module('mauiApp').directive 'groupJoinBtn', ()->
  templateUrl: 'app/group/groupTile/groupJoinBtn.html'
  restrict: 'E'
  replace: true
  scope:
    group: '='
    me: '='

  controller: ($scope, Restangular, notify, $state, $modal)->

    angular.extend $scope,
      editGroupInfo: ($event)->
        $event?.stopPropagation()
        $modal.open
          templateUrl: 'app/group/editGroup/editGroupModal.html'
          controller: 'EditGroupModalCtrl'
          size: 'sm'
          resolve:
            group: -> angular.copy($scope.group)
        .result.then (newGroup) ->
          angular.extend $scope.group, newGroup

      joinGroup: ->
        Restangular.one('groups', $scope.group._id).one('join')
        .post()
        .then (data)->
          $scope.role = 'member'
          notify
            message: '已加入小组'
            classes: 'alert-success'
        .catch (error) ->
          $scope.errors = error?.data?.errors

      leaveGroup: ($event)->
        $event?.stopPropagation()
        Restangular.one('groups', $scope.group._id).one('leave')
        .post()
        .then (data)->
          $scope.role = 'passerby'
          notify
            message: '已退出小组'
            classes: 'alert-success'
        .catch (error) ->
          $scope.errors = error?.data?.errors


    getRole = ->
      if !$scope.me._id?
        $scope.role =  'passerby'
      else if $scope.me._id == $scope.group?.creator?._id
        $scope.role = 'creator'
      else
        Restangular.one('groups', $scope.group._id).one('getRole').get()
        .then (data)->
          $scope.role = data.role

    $scope.$watchGroup ['group','me'], ->
      if $scope.group
        getRole()

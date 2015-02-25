'use scrict'

angular.module('mauiApp')

.controller 'EditGroupModalCtrl', (
  $scope
  $state
  notify
  messageModal
  Restangular
  $modalInstance
  group
  configs
) ->

  angular.extend $scope,
    errors: {}
    format: ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate']
    group: group
    imageSizeLimitation: configs.imageSizeLimitation
    onLogoUpload: ($data)->
      console.log $data
      group.logo = $data

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      console.log $scope.group
      $scope.submitted = true
      if !form.$valid then return
      $scope.group.logo
      (
        if $scope.group._id?
          Restangular.one('groups', $scope.group._id).patch($scope.group)
        else
          Restangular.all('groups').post($scope.group)
      )
      .then $modalInstance.close
      .catch (error) ->
        angular.forEach error?.data?.errors, (error, field) ->
          console.log field
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message

    removeGroup: ->
      messageModal.open
        title: -> '删除小组'
        message: -> "确定要删除该小组吗？"
      .result.then ->
        $scope.group.remove().then ->
          notify
            message: '小组已经删除'
            classes: 'alert-success'
          $modalInstance.dismiss('cancel')
          $state.go 'groupList', {}, {reload: true}
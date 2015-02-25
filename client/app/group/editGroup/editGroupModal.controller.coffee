'use scrict'

angular.module('mauiApp')

.controller 'EditGroupModalCtrl', (
  $scope
  notify
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
      group.logo = $data

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
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
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message

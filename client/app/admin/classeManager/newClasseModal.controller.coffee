'use scrict'

angular.module('budweiserApp').controller 'NewClasseModalCtrl', (
  $scope
  Restangular
  $modalInstance
) ->

  angular.extend $scope,
    classe:
      name: ''

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      if !form.$valid then return
      Restangular.all('classes').post($scope.classe)
      .then $modalInstance.close
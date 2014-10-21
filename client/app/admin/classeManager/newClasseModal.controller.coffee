'use scrict'

angular.module('budweiserApp').controller 'NewClasseCtrl', (
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
      Restangular.all('classes').post($scope.classe).then (newClasse) ->
        $modalInstance.close newClasse
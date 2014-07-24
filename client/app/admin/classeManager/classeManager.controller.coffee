'use strict'

angular.module('budweiserApp').controller 'ClasseManagerCtrl', ($scope,$state,Restangular,Auth, $http,$upload) ->
  $scope.classes = []
  Restangular.all('classes').getList()
  .then (classes)->
    $scope.classes = classes

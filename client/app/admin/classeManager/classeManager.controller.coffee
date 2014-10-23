'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerCtrl', (
  $state
  $scope
  Classes
) ->

  viewFirstClasse = ->
    classes = $scope.classes
    $scope.viewClasse(classes[0]) if classes.length > 0

  angular.extend $scope,
    classes: Classes
    selectedClasse: null

    onCreateClasse: (classe) ->
      $scope.classes.push classe

    onDeleteClasses: (classes) ->
      angular.forEach classes, (c) ->
        $scope.classes.splice($scope.classes.indexOf(c), 1)
      viewFirstClasse() if $scope.classes.indexOf($scope.selectedClasse) == -1

    viewClasse: (classe) ->
      $state.go('admin.classeManager.detail', classeId:classe._id) if classe?

  $scope.$on '$stateChangeSuccess', (event, toState) ->
    viewFirstClasse() if toState.name == 'admin.classeManager'

'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerCtrl', (
  $q
  $modal
  $state
  $scope
  notify
  Classes
  Restangular
) ->

  updateSelected = ->
    $scope.selectedClasses =  _.filter(Classes, '$selected':true)

  angular.extend $scope,
    $state: $state
    selectedClasse: null
    selectedClasses: []
    selectedAllClass: false
    classes: Classes

    deleteClasses: (selectedClasses) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除班级'
          message: ->
            """确认要删除这#{selectedClasses.length}个班级？"""
      .result.then ->
        $scope.selectedAllClasse = false if $scope.selectedAllClasse
        $scope.deleting = true
        Restangular.all('classes').customPOST(ids: _.pluck(selectedClasses, '_id'), 'multiDelete')
        .then ->
          $scope.deleting = false
          angular.forEach selectedClasses, (c) ->
            $scope.classes.splice($scope.classes.indexOf(c), 1)
          $state.go('admin.classeManager') if $scope.classes.indexOf($scope.selectedClasse) == -1

    createNewClasse: ->
      $modal.open
        templateUrl: 'app/admin/classeManager/newClasseModal.html'
        controller: 'NewClasseModalCtrl'
        size: 'sm'
      .result.then (newClasse) ->
        $scope.classes.push(newClasse)
        $state.go('admin.classeManager.detail', classeId:newClasse._id)
        notify
          message: '新班级添加成功'
          classes: 'alert-success'

    toggleSelect: (classes, selected) ->
      angular.forEach classes, (c) -> c.$selected = selected
      updateSelected()

  $scope.$watch 'classes.length', updateSelected

  $scope.$on '$stateChangeSuccess', (event, toState) ->
    if toState.name == 'admin.classeManager' && Classes.length > 0
      $state.go('admin.classeManager.detail', classeId:Classes[0]._id)


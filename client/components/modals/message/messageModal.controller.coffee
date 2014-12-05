'use strict'

angular.module('maui.components').controller 'MessageModalCtrl', (
  title
  $scope
  message
  $modalInstance
) ->
  angular.extend $scope,
    title: title
    message: message
    cancel: ->
      $modalInstance.dismiss()
    confirm: ->
      $modalInstance.close()


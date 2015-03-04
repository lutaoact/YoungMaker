'use strict'

angular.module('maui.components')

.controller 'AddWeixinModalCtrl', (
  $scope
  $modalInstance
) ->

  angular.extend $scope,
    close: ->
      $modalInstance.dismiss('cancel')

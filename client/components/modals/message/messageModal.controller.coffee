'use strict'

angular.module('maui.components')

.factory 'messageModal', ($modal) ->
  open: (resolve) ->
    $modal.open
      templateUrl: 'components/modals/message/messageModal.html'
      windowClass: 'message-modal'
      controller: 'MessageModalCtrl'
      size: 'sm'
      resolve:
        title: resolve.title
        message: resolve.message
        buttons: resolve.buttons ? -> [
          label: '取消' , code: 'cancel' , class: 'btn-default'
        ,
          label: '确认' , code: 'ok'     , class: 'btn-danger'
        ]

.controller 'MessageModalCtrl', (
  title
  $scope
  message
  buttons
  $modalInstance
) ->
  angular.extend $scope,
    title   : title
    buttons : buttons
    message : message

    close: (code) ->
      if code is 'cancel'
        $modalInstance.dismiss('cancel')
      else
        $modalInstance.close(code)

'use strict'

angular.module('budweiserApp')

.directive 'uploader', ->
  restrict: 'EA'
  transclude: true
  replace: true
  controller: 'UploadCtrl'
  templateUrl: 'app/directives/uploader/uploader.html'
  scope:
    limit: '='
    accept: '@'
    multiple: '='
    onStart: '&'
    onProgress: '&'
    onConvert: '&'
    onComplete: '&'
    onError: '&'

.controller 'UploadCtrl', (
  $scope
  fileUtils
) ->

  angular.extend $scope,

    onFileSelect: (files) ->
      $scope.uploadState = 'uploading'

      $scope.onStart?($files:files)
      fileUtils.uploadFile
        files: files
        validation:
          max: $scope.limit ? 50*1024*1024
        success: (data) ->
          $scope.uploadState = null
          $scope.onComplete?($data:data)
        fail: (error)->
          $scope.uploadState = null
          $scope.onError?($error:error)
        progress: (speed, percentage, evt)->
          $scope.uploadProgress =
            if files.length == 1
              parseInt(percentage) + '%'
            else
              ''
          $scope.onProgress?($speed:speed, $percentage:percentage, $event:evt)
        convert: ->
          $scope.uploadState = 'converting'
          $scope.onConvert?()

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
      $scope.uploading = true

      $scope.onStart?($files:files)
      fileUtils.uploadFile
        files: files
        validation:
          max: $scope.limit ? 50*1024*1024
        success: (data) ->
          $scope.uploading = false
          $scope.onComplete?($data:data)
        fail: (error)->
          $scope.uploading = false
          $scope.onError?($error:error)
        progress: (speed, percentage, evt)->
          $scope.uploadProgress =
            if files.length == 1
              parseInt(percentage) + '%'
            else
              ''
          $scope.onProgress?($speed:speed, $percentage:percentage)
        convert: ->
          $scope.onConvert?()

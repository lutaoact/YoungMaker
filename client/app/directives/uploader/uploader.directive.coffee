'use strict'

angular.module('budweiserApp')

.directive 'uploader', ->
  restrict: 'EA'
  transclude: true
  controller: 'UploadCtrl'
  templateUrl: 'app/directives/uploader/uploader.html'
  scope:
    limit: '='
    accept: '@'
    multiple: '='
    onError: '&'
    onComplete: '&'

.controller 'UploadCtrl', (
  $scope
  fileUtils
) ->

  angular.extend $scope,

    onFileSelect: (files) ->
      $scope.uploading = true

      methodName = if $scope.multiple then 'bulkUpload' else if $scope.accept is 'ppt' then 'uploadSlides' else 'uploadFile'
      fileUtils[methodName]
        files: files
        validation:
          max: $scope.limit ? 50*1024*1024
          accept: $scope.accept
        success: (data, rawData) ->
          $scope.uploading = false
          $scope.onComplete?($data:data,$rawData:rawData)
        fail: (error)->
          $scope.uploading = false
          $scope.onError?($error:error)
        progress: (speed, percentage, evt)->
          $scope.uploadProgress =
            if files.length == 1
              parseInt(100.0 * evt.loaded / evt.total) + '%'
            else
              ''

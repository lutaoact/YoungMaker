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
    onError: '&'
    onComplete: '&'

.controller 'UploadCtrl', (
  $scope
  fileUtils
) ->

  angular.extend $scope,

    onFileSelect: (files) ->
      $scope.uploading = true

      methodName =
        if $scope.multiple then 'bulkUpload'
        else if $scope.accept.indexOf('.ppt') >= 0 then 'uploadSlides'
        else if $scope.accept.indexOf('video') >= 0 then 'uploadVideo'
        else 'uploadFile'
      fileUtils[methodName]
        files: files
        validation:
          max: $scope.limit ? 50*1024*1024
        success: (data, rawData) ->
          $scope.uploading = false
          $scope.onComplete?($data:data,$rawData:rawData)
        fail: (error)->
          $scope.uploading = false
          $scope.onError?($error:error)
        progress: (speed, percentage, evt)->
          $scope.uploadProgress =
            if files.length == 1
              parseInt(percentage) + '%'
            else
              ''

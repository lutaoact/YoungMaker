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
    acceptType: '@'
    multiple: '='
    onStart: '&'
    onProgress: '&'
    onConvert: '&'
    onComplete: '&'
    onError: '&'
    crop: '@'
    cropRatio: '@'
    maxWidth: '@'

.controller 'UploadCtrl', (
  $scope
  fileUtils
  $modal
) ->

  angular.extend $scope,

    getAcceptValue: ->
      switch $scope.acceptType
        when 'slides'
          'application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.slideshow,application/vnd.openxmlformats-officedocument.presentationml.presentation'
        when 'image'
          'image/*'
        when 'video'
          'video/mp4,video/x-m4v,video/*'
        else
          ''
    onFileSelect: (files) ->
      if not files?.length
        return

      $scope.uploadState = 'uploading'
      if $scope.crop
        $modal.open
          templateUrl: 'app/imageCrop/imageCropPopup.html'
          controller: 'ImageCropPopupCtrl'
          resolve:
            files: -> files
            options: ->
              maxWidth: $scope.maxWidth
              ratio: $scope.cropRatio
        .result.then (url, raw)->
          # file is uploaded successfully
          $scope.uploadState = null
          $scope.onComplete?($data:url)
        , ()->
          $scope.uploadState = null
          console.log 'dismiss'
      else

        $scope.onStart?($files:files)
        fileUtils.uploadFile
          files: files
          validation:
            max: $scope.limit ? 50*1024*1024
            accept: $scope.acceptType
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

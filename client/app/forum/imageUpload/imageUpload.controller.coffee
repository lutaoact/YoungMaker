angular.module('budweiserApp').controller 'ImageUploadCtrl', (
  $scope
  $modalInstance
  qiniuUtils
  notify
  $timeout
) ->
  console.log 'in'
  angular.extend $scope,
    close: ->
      $modalInstance.dismiss('close')

    viewState: {}

    files: undefined

    onFileSelect: (files)->
      if not files?.length
        notify('请选择文件')
        return
      if not /^image\//.test files[0].type
        notify('请选择正确文件')
        return
      $scope.files = files
      reader = new FileReader()
      reader.onload = (event) ->
        $timeout ()->
          $scope.viewState.previewUrl = event.target.result
      reader.readAsDataURL(files[0])

    confirm: () ->
      $scope.viewState.uploading = true
      qiniuUtils.uploadFile
        files: $scope.files
        validation:
          max: 5*1024*1024
          accept: 'image'
        rename: 'index'
        success: (key) ->
          $scope.viewState.uploading = false
          result = "/api/qiniu/images/#{key}" + '-blog'
          $modalInstance.close result
        fail: (error)->
          $scope.viewState.uploading = false
          notify(error)
        progress: (speed,percentage, evt)->
          $scope.viewState.uploadProgress = parseInt(100.0 * evt.loaded / evt.total) + '%'


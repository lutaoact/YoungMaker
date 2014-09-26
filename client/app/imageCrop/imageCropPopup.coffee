angular.module('budweiserApp').controller 'ImageCropPopupCtrl', (
  $scope
  $modalInstance
  fileUtils
  notify
  $timeout
  files
  options
) ->
  angular.extend $scope,
    close: ->
      $modalInstance.dismiss('close')

    viewState: {}

    files: files

    onFileSelect: ($event, files)->
      if not files?.length
        notify('请选择文件')
        return
      if not /^image\//.test files[0].type
        notify('请选择正确文件')
        return
      $scope.files = files

    confirm: () ->
      $scope.viewState.uploading = true
      fileUtils.uploadFile
        files: $scope.files
        validation:
          max: 2*1024*1024
          accept: 'image'
        rename: 'index'
        success: (key) ->
          $scope.viewState.uploading = false
          console.log $scope.viewState
          suffix = '?imageMogr2/auto-orient'
          if $scope.viewState.start
            cropSize =
              width: $scope.viewState.originSize.width / $scope.viewState.size.width * ($scope.viewState.end.x - $scope.viewState.start.x)
              height: $scope.viewState.originSize.height / $scope.viewState.size.height * ($scope.viewState.end.y - $scope.viewState.start.y)
            cropOffset =
              x: $scope.viewState.originSize.width / $scope.viewState.size.width * $scope.viewState.start.x
              y: $scope.viewState.originSize.height / $scope.viewState.size.height * $scope.viewState.start.y
            suffix += "/crop/!" + ~~cropSize.width + 'x' + ~~cropSize.height + 'a' + ~~cropOffset.x + 'a' + ~~cropOffset.y

          if options.maxWidth
            suffix += '/thumbnail/' + ~~options.maxWidth + 'x'

          result = "/api/assets/images/#{key}" + suffix

          $modalInstance.close result,
            key: key
            cropSize: cropSize
            cropOffset: cropOffset
            originSize: $scope.viewState.originSize
        fail: (error)->
          $scope.viewState.uploading = false
          notify(error)
        progress: (speed, percentage, evt)->
          $scope.viewState.uploadProgress = parseInt(100.0 * evt.loaded / evt.total) + '%'

    mouseDown: ($event)->
      $event.preventDefault()
      @viewState.cropping = !@viewState.cropped
      @viewState.cropped = !@viewState.cropped
      if @viewState.cropping
        @viewState.start =
          x: $event.offsetX
          y: $event.offsetY
        @viewState.end =
          x: $event.offsetX
          y: $event.offsetY

    mouseUp: ($event)->
      $event.preventDefault()
      if $scope.viewState.cropping
        $scope.viewState.cropping = false
        $scope.viewState.cropped = true
        if options.ratio
          if ($event.offsetX - $scope.viewState.start.x) / ($event.offsetY - $scope.viewState.start.y) < options.ratio
            @viewState.end =
              x: $event.offsetX
              y: $scope.viewState.start.y + ($event.offsetX - $scope.viewState.start.x) / options.ratio
          else
            @viewState.end =
              x: $scope.viewState.start.x + ($event.offsetY - $scope.viewState.start.y) * options.ratio
              y: $event.offsetY
        else
          @viewState.end =
            x: $event.offsetX
            y: $event.offsetY

    mouseMove: ($event)->
      $event.preventDefault()
      if $scope.viewState.cropping
        if options.ratio
          if ($event.offsetX - $scope.viewState.start.x) / ($event.offsetY - $scope.viewState.start.y) < options.ratio
            @viewState.end =
              x: $event.offsetX
              y: $scope.viewState.start.y + ($event.offsetX - $scope.viewState.start.x) / options.ratio
          else
            @viewState.end =
              x: $scope.viewState.start.x + ($event.offsetY - $scope.viewState.start.y) * options.ratio
              y: $event.offsetY
        else
          @viewState.end =
            x: $event.offsetX
            y: $event.offsetY

  $scope.$watch 'files', (value)->
    if value
      reader = new FileReader()
      reader.onload = (event) ->
        $timeout ()->
          $scope.viewState.previewUrl = event.target.result
        angular.element('.img-preview').on 'load', (e)->
          console.log e
          if e.target.clientWidth < 250
            $scope.viewState.size =
              width: 250
              height: ~~(e.target.clientHeight * 250 / e.target.clientWidth)
          else
            $scope.viewState.size =
              width: e.target.clientWidth
              height: e.target.clientHeight
          $scope.viewState.originSize =
            width: e.target.naturalWidth
            height: e.target.naturalHeight
          angular.element('.bud.thumbnail').css 'width', $scope.viewState.size.width
          angular.element('.bud.thumbnail').css 'height', $scope.viewState.size.height
          angular.element('.img-preview').css 'width', $scope.viewState.size.width
          angular.element('.img-preview').css 'height', $scope.viewState.size.height

      reader.readAsDataURL(value[0])



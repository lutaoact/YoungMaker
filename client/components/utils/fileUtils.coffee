angular.module 'budweiserApp'
.factory 'fileUtils', ($upload, $http, $q, Restangular)->
  rexDict =
    ppt: /^application\/(vnd.ms-powerpoint|vnd.openxmlformats-officedocument.presentationml.slideshow|vnd.openxmlformats-officedocument.presentationml.presentation)$/
    image: /^image\//
    excel: /^application\//

  validate = (validation, file)->
    throwFileEx = (fileName)->
      '文件： ' + fileName + ' 格式错误'
    if (validation?.max or Infinity) < file.size
      return '文件： ' + file.name + ' 过大'

    fileType = validation?.accept or 'all'
    return throwFileEx(file.name) if rexDict[fileType]?.test file.type is false

    true

  uploadFile: (opts)->

    if not opts.files? or opts.files.length < 1
      opts.fail?('file not selected')
      return

    file = opts.files[0]
    validateResult = validate(opts.validation, file)
    return opts.fail?(validateResult) unless validateResult is true

    # get upload token
    Restangular.one('assets/upload/images','').get(fileName: file.name)
    .then (strategy)->
      start = moment()
      $upload.upload
        url: strategy.url
        method: 'POST'
        data: strategy.formData
        withCredentials: false
        file: file
        fileFormDataName: 'file'
      .progress (evt)->
        speed = evt.loaded / (moment().valueOf() - start.valueOf())
        percentage = parseInt(100.0 * evt.loaded / evt.total)
        opts.progress?(speed,percentage, evt)
      .success (data) ->
        opts.success?(strategy.formData.key, data)
      .error opts.fail
    , opts.fail

  bulkUpload: (opts)->

    if not opts.files? or opts.files.length < 1
      opts.fail?('file not selected')
      return

    promises = []
    for file in opts.files
      do (file)->
        validateResult = validate(opts.validation, file)
        return opts.fail?(validateResult) unless validateResult is true

        deferred = $q.defer()
        promises.push deferred.promise
        # get upload token
        Restangular.one('assets/upload/slides','').get(fileName: file.name)
        .then (strategy)->
          start = moment()
          $upload.upload
            url: strategy.url
            method: 'POST'
            data: strategy.formData
            withCredentials: false
            file: file
            fileFormDataName: 'file'
          .progress (evt)->
            speed = evt.loaded / (moment().valueOf() - start.valueOf())
            percentage = parseInt(100.0 * evt.loaded / evt.total)
            opts.progress?(speed,percentage, evt)
          .success (data) ->
            deferred.resolve strategy.formData.key
          .error (response)->
            deferred.reject()
        , (error)->
          console.log error
          deferred.reject()

    $q.all(promises).then (result)->
      keys = []
      for data in result
        keys.push data
      opts.success?(keys)
    , opts.fail

  uploadSlides: (opts)->

    if not opts.files? or opts.files.length < 1
      opts.fail?('file not selected')
      return

    file = opts.files[0]
    validateResult = validate(opts.validation, file)
    return opts.fail?(validateResult) unless validateResult is true

    # get upload token
    # TODO: tell qiniu the max size and accept types
    Restangular.one('assets/upload/slides','').get(fileName: file.name)
    .then (strategy)->
      start = moment()
      $upload.upload
        url: strategy.url
        method: 'POST'
        data: strategy.formData
        withCredentials: false
        file: file
        fileFormDataName: 'file'
      .progress (evt)->
        speed = evt.loaded / (moment().valueOf() - start.valueOf())
        percentage = parseInt(100.0 * evt.loaded / evt.total)
        opts.progress?(speed,percentage, evt)
      .success (data) ->
        opts.success?(strategy.formData.key, data)
      .error opts.fail
    , opts.fail


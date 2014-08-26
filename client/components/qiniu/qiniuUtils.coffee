angular.module 'budweiserApp'
.factory 'qiniuUtils', ($upload, $http,$q)->
  validate = (validation, file)->
    throwFileEx = (fileName)->
      '文件： ' + fileName + ' 格式错误'
    if (validation?.max or Infinity) < file.size
      return '文件： ' + file.name + ' 过大'

    switch validation?.accept or 'all'
      when 'ppt'
        if not /^(application\/vnd.ms-powerpoint|application\/vnd.openxmlformats-officedocument.presentationml.slideshow|application\/vnd.openxmlformats-officedocument.presentationml.presentation)$/.test file.type
          return throwFileEx(file.name)

      when 'image'
        if not /^image\//.test file.type
          return throwFileEx(file.name)

    true

  uploadFile: (opts)->

    if not opts.files? or opts.files.length < 1
      opts.fail?('file not selected')
      return

    file = opts.files[0]
    validateResult = validate(opts.validation, file)
    return opts.fail?(validateResult) unless validateResult is true

    # get upload token
    # TODO: tell qiniu the max size and accept types
    $http.get('/api/qiniu/uptoken')
    .success (uploadToken)->
      qiniuParam =
        'key': uploadToken.random + '/' + utf8.encode(file.name)
        'token': uploadToken.token
      start = moment()
      $upload.upload
        url: 'http://up.qiniu.com'
        method: 'POST'
        data: qiniuParam
        withCredentials: false
        file: file
        fileFormDataName: 'file'
      .progress (evt)->
        speed = evt.loaded / (moment().valueOf() - start.valueOf())
        percentage = parseInt(100.0 * evt.loaded / evt.total)
        opts.progress?(speed,percentage, evt)
      .success (data) ->
        opts.success?(data.key)
      .error opts.fail
    .error opts.fail

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
        $http.get('/api/qiniu/uptoken')
        .success (uploadToken)->
          qiniuParam =
            'key': uploadToken.random + '/' + utf8.encode(file.name)
            'token': uploadToken.token
          start = moment()
          $upload.upload
            url: 'http://up.qiniu.com'
            method: 'POST'
            data: qiniuParam
            withCredentials: false
            file: file
            fileFormDataName: 'file'
          .progress (evt)->
            speed = evt.loaded / (moment().valueOf() - start.valueOf())
            percentage = parseInt(100.0 * evt.loaded / evt.total)
            opts.progress?(speed,percentage, evt)
          .success (data) ->
            deferred.resolve data
          .error (response)->
            deferred.reject()
        .error ()->
          deferred.reject()

    $q.all(promises).then (result)->
      keys = []
      for data in result
        keys.push data.key
      opts.success?(keys)
    , opts.fail


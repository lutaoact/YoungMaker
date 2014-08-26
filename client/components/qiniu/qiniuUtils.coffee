angular.module 'budweiserApp'
.factory 'qiniuUtils', ($upload, $http,$q)->
  uploadFile: (opts)->
    if not opts.files? or opts.files.length < 1
      opts.fail?('file not selected')
      return
    switch opts.validation.accept or 'all'
      when 'ppt'
        if not /^(application\/vnd.ms-powerpoint|application\/vnd.openxmlformats-officedocument.presentationml.slideshow|application\/vnd.openxmlformats-officedocument.presentationml.presentation)$/.test opts.files[0].type
          opts.fail?('invalid file type')
          return
    if opts.validation.max and opts.validation.max < opts.files[0].size
      opts.fail?('size exceeded')
      return
    file = opts.files[0]
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
        if opts.progress
          opts.progress(speed,percentage, evt)
      .success (data) ->
        opts.success(data.key)
      .error opts.fail
    .error opts.fail

  bulkUpload: (opts)->
    if not opts.files? or opts.files.length < 1
      opts.fail?('file not selected')
      return
    promises = []
    for file in opts.files
      do (file)->
        deferred = $q.defer()
        switch opts.validation.accept or 'all'
          when 'ppt'
            if not /^(application\/vnd.ms-powerpoint|application\/vnd.openxmlformats-officedocument.presentationml.slideshow|application\/vnd.openxmlformats-officedocument.presentationml.presentation)$/.test file.type
              opts.fail?('文件： ' + file.name + ' 格式错误')
              return
          when 'image'
            if not /^image\//.test file.type
              console.log file.type
              opts.fail?('文件： ' + file.name + ' 格式错误')
              return
        if opts.validation.max and opts.validation.max < file.size
          opts.fail?('文件： ' + file.name + ' 过大')
          return
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
            if opts.progress
              opts.progress(speed,percentage, evt)
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
      opts.success(keys)
    , opts.fail


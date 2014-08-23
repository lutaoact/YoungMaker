angular.module 'budweiserApp'
.factory 'qiniuUtils', ($upload, $http,$q)->
  uploadFile: (files, validation, success, fail, progress)->
    if not files? or files.length < 1
      fail?('file not selected')
      return
    switch validation.accept or 'all'
      when 'ppt'
        if not /^(application\/vnd.ms-powerpoint|application\/vnd.openxmlformats-officedocument.presentationml.slideshow|application\/vnd.openxmlformats-officedocument.presentationml.presentation)$/.test files[0].type
          fail?('invalid file type')
          return
    if validation.max and validation.max < files[0].size
      fail?('size exceeded')
      return
    file = files[0]
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
        if progress
          progress(speed,percentage, evt)
      .success (data) ->
        success(data.key)
      .error fail
    .error fail

  bulkUpload: (files, validation, success, fail, progress)->
    if not files? or files.length < 1
      fail?('file not selected')
      return
    promises = []
    for file in files
      do (file)->
        deferred = $q.defer()
        switch validation.accept or 'all'
          when 'ppt'
            if not /^(application\/vnd.ms-powerpoint|application\/vnd.openxmlformats-officedocument.presentationml.slideshow|application\/vnd.openxmlformats-officedocument.presentationml.presentation)$/.test file.type
              fail?('文件： ' + file.name + ' 格式错误')
              return
          when 'image'
            if not /^image\//.test file.type
              console.log file.type
              fail?('文件： ' + file.name + ' 格式错误')
              return
        if validation.max and validation.max < file.size
          fail?('文件： ' + file.name + ' 过大')
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
            if progress
              progress(speed,percentage, evt)
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
      success(keys)
    , fail


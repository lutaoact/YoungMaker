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

  uploadVideo: (opts)->
    if not opts.files? or opts.files.length < 1
      opts.fail?('file not selected')
      return

    file = opts.files[0]
    validateResult = validate(opts.validation, file)
    return opts.fail?(validateResult) unless validateResult is true

    # get upload token
    Restangular.one('assets/upload/videos','').get(fileName: file.name)
    .then (strategy)->
      startTime = moment()
      pipeUpload = (file, segment ,request)->
        uploadQ = $q.defer()
        pieces = Math.ceil(file.size / segment)
        pad = (number, length) ->
          str = '' + number
          while str.length < length
            str = '0' + str
          str
        blocklist = [1..pieces].map (i) -> btoa('blick-' + pad(i, 6))
        commitBlockList = ()->
          deferred = $q.defer()
          url = request.url + '&comp=blocklist'
          requestBody = '<?xml version="1.0" encoding="utf-8"?><BlockList>';
          requestBody += (blocklist.map (i)-> '<Latest>' + i + '</Latest>').join('')
          requestBody += '</BlockList>'
          $.ajax
            url: url
            type: "PUT"
            data: requestBody
            beforeSend:  (xhr) ->
              xhr.setRequestHeader('x-ms-blob-content-type', file.type)
            success: (data, status) ->
              deferred.resolve data
            error: (xhr, desc, err) ->
              console.log(err)
          deferred.promise


        readBlob = (start, end)->
          deferred = $q.defer()
          blob = file.slice(start, end)
          fileReader = new FileReader()
          fileReader.readAsArrayBuffer(blob)
          fileReader.onload = (e)->
            deferred.resolve e.target.result
          deferred.promise
        current = 0
        currentEnd = if current + segment >= file.size - 1 then file.size - 1 else current + segment
        uploadPiece = (current, currentEnd)->
          currentEnd = if currentEnd >= file.size - 1 then file.size - 1 else currentEnd
          readBlob(current, currentEnd)
          .then (data)->
            request.data = data
            $.ajax
              url: request.url + '&comp=block&blockid=' + blocklist[Math.ceil(currentEnd / segment) - 1]
              type: request.method
              data: data
              processData: false
              beforeSend: (xhr)->
                xhr.setRequestHeader('x-ms-blob-type', 'BlockBlob')
                xhr.setRequestHeader('Content-Length', data.length)
              success: (data)->
                speed = currentEnd / (moment().valueOf() - startTime.valueOf())
                percentage = parseInt(100.0 * currentEnd / file.size)
                opts.progress?(speed,percentage)
                if currentEnd == file.size - 1
                  # Done
                  commitBlockList()
                  .then ()->
                    uploadQ.resolve data
                else
                  uploadPiece(currentEnd, currentEnd + segment)

        uploadPiece current, currentEnd
        uploadQ.promise

      request =
        url: strategy.url
        method: 'PUT'
        headers:
          'x-ms-blob-type': 'BlockBlob'
          'x-ms-version': '2013-08-15'
          'Content-Type': 'application/octet-stream'
          'Content-Length': file.size
        withCredentials: false
      pipeUpload(file, 4 * 1024 * 1024,request)
      .then (data)->
        opts.success?(strategy.key, data)
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


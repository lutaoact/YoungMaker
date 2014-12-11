require '../common/init'
AdapterUtils = _u.getUtils 'adapter'

class WrapRequest
  constructor: (@Model) ->

  wrapIndex: () ->
    return (req, res, next) =>
      conditions = AdapterUtils.buildConditions req.query
      options =
        from : ~~req.query.from #from参数转为整数
        limit: ~~req.query.limit

      AdapterUtils.getCountAndPageInfo @Model, conditions, options
      .then (data) ->
        res.send
          results: data[0]
          count: data[1]
      .catch next
      .done()

  wrapCommonShow: () ->
    return (req, res, next) =>
      _id = req.params.id

      modelName = @Model.constructor.name
      @Model.findById _id
      .populate fieldMap[modelName].field, fieldMap[modelName].populate
      .execQ()
      .then (doc) ->
        res.send doc
      .catch next
      .done()

  wrapShow: () ->
    return (req, res, next) =>
      _id = req.params.id

      modelName = @Model.constructor.name
      @Model.findByIdQ _id
      .then (doc) ->
        doc.viewersNum += 1 #每次调用API，相当于查看一次
        do doc.saveQ
      .then (result) ->
        result[0].populateQ fieldMap[modelName].field, fieldMap[modelName].populate
      .then (doc) ->
        res.send doc
      .catch next
      .done()

  wrapCreate: (pickedKeys) ->
    return (req, res, next) =>
      data = _.pick req.body, pickedKeys
      data[fieldMap[@Model.constructor.name].field] = req.user._id

      @Model.createQ data
      .then (newDoc) ->
        res.send newDoc
      .catch next
      .done()

  wrapUpdate: (pickedUpdatedKeys) ->
    return (req, res, next) =>
      _id = req.params.id
      user = req.user

      #拣选出允许更新的字段
      data = _.pick req.body, pickedUpdatedKeys

      @Model.getByIdAndUser _id, user._id
      .then (doc) ->
        updated = _.extend doc, body
        do updated.saveQ
      .then (result) ->
        res.send result[0]
      .catch next
      .done()

  wrapDestroy: () ->
    return (req, res, next) =>
      _id = req.params.id
      @Model.updateQ {_id: _id}, {deleteFlag: true}
      .then () ->
        res.send 204
      .catch next
      .done()

  wrapLike: () ->
    return (req, res, next) =>
      _id = req.params.id
      user = req.user
      AdapterUtils.like @Model, _id, user._id
      .then (doc) ->
        res.send doc
      .catch next
      .done()


module.exports = WrapRequest

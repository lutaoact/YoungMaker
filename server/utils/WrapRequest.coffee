require '../common/init'
LikeUtils = _u.getUtils 'like'

class WrapRequest
  constructor: (@Model) ->

  wrapIndex: () ->
    return (req, res, next) =>
      conditions = LikeUtils.buildConditions req.query
      options =
        from : ~~req.query.from #from参数转为整数
        limit: ~~req.query.limit

      LikeUtils.getCountAndPageInfo @Model, conditions, options
      .then (data) ->
        res.send
          results: data[0]
          count: data[1]
      .catch next
      .done()

  wrapShow: () ->
    return (req, res, next) =>
      _id = req.params.id

      @Model.findByIdQ _id
      .then (doc) ->
        doc.viewersNum += 1 #每次调用API，相当于查看一次
        do doc.saveQ
      .then (result) ->
        result[0].populateQ 'author', 'name'
      .then (doc) ->
        res.send doc
      .catch next
      .done()

  wrapCreate: (pickedKeys) ->
    return (req, res, next) =>
      data = _.pick req.body, pickedKeys
      data.author = req.user._id

      @Model.createQ data
      .then (newDoc) ->
        res.send newDoc
      .catch next
      .done()


module.exports = WrapRequest

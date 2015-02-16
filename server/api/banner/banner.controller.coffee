Banner = _u.getModel 'banner'

WrapRequest = new (require '../../utils/WrapRequest')(Banner)

exports.index = (req, res, next) ->
  conditions = {}
  WrapRequest.wrapIndex req, res, next, conditions

pickedKeys = ['text', 'image', 'link']
exports.create = (req, res, next) ->
  data = _.pick req.body, pickedKeys
  WrapRequest.wrapCreate req, res, next, data

pickedUpdatedKeys = ['text', 'image', 'link']
exports.update = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys

exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapDestroy req, res, next, conditions

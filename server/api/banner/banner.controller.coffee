Banner = _u.getModel 'banner'

WrapRequest = new (require '../../utils/WrapRequest')(Banner)

exports.index = (req, res, next) ->
  conditions = {}
  conditions.type = req.query.type if req.query.type
  WrapRequest.wrapIndex req, res, next, conditions

pickedKeys = ['text', 'image', 'link', 'type', 'seq']
exports.create = (req, res, next) ->
  data = _.pick req.body, pickedKeys
  WrapRequest.wrapCreate req, res, next, data

pickedUpdatedKeys = ['text', 'image', 'link', 'seq']
exports.update = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys

exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapDestroy req, res, next, conditions

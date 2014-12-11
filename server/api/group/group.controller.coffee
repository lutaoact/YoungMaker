'use strict'

Group = _u.getModel 'group'
WrapRequest = new (require '../../utils/WrapRequest')(Group)

exports.index = WrapRequest.wrapIndex()

exports.show = WrapRequest.wrapCommonShow()

pickedKeys = ['title', 'description']
exports.create = WrapRequest.wrapCreate pickedKeys

pickedUpdatedKeys = ['title', 'description', 'avatar']
exports.update = WrapRequest.wrapUpdate pickedUpdatedKeys

exports.destroy = WrapRequest.wrapDestroy()

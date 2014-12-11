'use strict'

Group = _u.getModel 'group'
WrapRequest = new (require '../../utils/WrapRequest')(Group)

exports.index = WrapRequest.wrapIndex()

exports.show = WrapRequest.wrapCommonShow()

pickedKeys = ['title', 'description']
exports.create = WrapRequest.wrapCreate pickedKeys

omittedKeys = ['_id', 'creator', 'members', 'deleteFlag']
exports.update = WrapRequest.wrapUpdate omittedKeys

exports.destroy = WrapRequest.wrapDestroy()

exports.like = WrapRequest.wrapLike()

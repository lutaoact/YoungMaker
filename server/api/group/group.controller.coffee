'use strict'

Group = _u.getModel 'group'
WrapRequest = new (require '../../utils/WrapRequest')(Group)

exports.index = WrapRequest.wrapIndex()

exports.show = WrapRequest.wrapShow()

pickedKeys = ['title', 'content', 'tags']
exports.create = WrapRequest.wrapCreate pickedKeys

omittedKeys = ['_id', 'author', 'commentsNum', 'viewersNum', 'likeUsers', 'deleteFlag']
exports.update = WrapRequest.wrapUpdate omittedKeys

exports.destroy = WrapRequest.wrapDestroy()

exports.like = WrapRequest.wrapLike()

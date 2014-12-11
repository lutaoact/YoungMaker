'use strict'

Article = _u.getModel 'article'
AdapterUtils = _u.getUtils 'adapter'
WrapRequest = new (require '../../utils/WrapRequest')(Article)

exports.index = WrapRequest.wrapIndex()

exports.show = WrapRequest.wrapShow()

pickedKeys = ['title', 'content', 'tags']
exports.create = WrapRequest.wrapCreate pickedKeys

pickedUpdatedKeys = ['title', 'content', 'tags']
exports.update = WrapRequest.wrapUpdate pickedUpdatedKeys

exports.destroy = WrapRequest.wrapDestroy()

exports.like = WrapRequest.wrapLike()

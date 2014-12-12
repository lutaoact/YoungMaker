'use strict'

Article = _u.getModel 'article'
AdapterUtils = _u.getUtils 'adapter'
WrapRequest = new (require '../../utils/WrapRequest')(Article)

exports.index = WrapRequest.wrapIndex()

exports.show = WrapRequest.wrapShow()

pickedKeys = ['title', 'image', 'content', 'tags', 'group']
exports.create = WrapRequest.wrapCreate pickedKeys

pickedUpdatedKeys = ['title', 'image', 'content', 'tags']
exports.update = WrapRequest.wrapUpdate pickedUpdatedKeys

exports.destroy = WrapRequest.wrapDestroy()

exports.like = WrapRequest.wrapLike()

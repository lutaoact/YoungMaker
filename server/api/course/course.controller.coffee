'use strict'

AdapterUtils = _u.getUtils 'adapter'
Course = _u.getModel 'course'
WrapRequest = new (require '../../utils/WrapRequest')(Course)

exports.index = WrapRequest.wrapIndex()

exports.show = WrapRequest.wrapShow()

pickedKeys = ['title', 'cover', 'image', 'videos', 'content', 'tags', 'steps']
exports.create = WrapRequest.wrapCreate pickedKeys

pickedUpdatedKeys = ['title', 'cover', 'image', 'videos', 'content', 'tags', 'steps']
exports.update = WrapRequest.wrapUpdate pickedUpdatedKeys

exports.destroy = WrapRequest.wrapDestroy()

exports.like = WrapRequest.wrapLike()

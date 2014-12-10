'use strict'

LikeUtils = _u.getUtils 'like'
Course = _u.getModel 'course'
WrapRequest = new (require '../../utils/WrapRequest')(Course)

exports.index = WrapRequest.wrapIndex()

exports.show = WrapRequest.wrapShow()

pickedKeys = ['title', 'cover', 'image', 'videos', 'content', 'tags', 'steps']
exports.create = WrapRequest.wrapCreate pickedKeys

omittedKeys = ['_id', 'author', 'commentsNum', 'viewersNum', 'likeUsers'
  'deleteFlag', 'pubAt'
]
exports.update = WrapRequest.wrapUpdate omittedKeys

exports.destroy = WrapRequest.wrapDestroy()

exports.like = WrapRequest.wrapLike()

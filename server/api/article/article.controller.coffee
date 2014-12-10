'use strict'

Article = _u.getModel 'article'
LikeUtils = _u.getUtils 'like'
WrapRequest = new (require '../../utils/WrapRequest')(Article)

exports.index = WrapRequest.wrapIndex()

exports.show = WrapRequest.wrapShow()

pickedKeys = ['title', 'content', 'tags']
exports.create = WrapRequest.wrapCreate pickedKeys

omittedKeys = ['_id', 'author', 'commentsNum', 'viewersNum', 'likeUsers', 'deleteFlag']
exports.update = WrapRequest.wrapUpdate omittedKeys

exports.destroy = WrapRequest.wrapDestroy()

exports.like = WrapRequest.wrapLike()

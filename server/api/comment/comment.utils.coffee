BaseUtils = require('../../common/BaseUtils')

class CommentUtils extends BaseUtils
  getCommentRefByType: (type) ->
    return _u.getModel Const.CommentRef[type]

exports.Instance = new CommentUtils()
exports.Class = CommentUtils

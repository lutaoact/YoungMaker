'use strict'

Comment = _u.getModel 'comment'
CommentUtils = _u.getUtils 'comment'
User = _u.getModel 'user'
testFilter = require '../../common/contentFilter'


WrapRequest = new (require '../../utils/WrapRequest')(Comment)

exports.index = (req, res, next) ->
  conditions = {}
  conditions.type = req.query.type if req.query.type
  conditions.belongTo = req.query.belongTo if req.query.belongTo
  WrapRequest.wrapPageIndex req, res, next, conditions

exports.create = (req, res, next) ->
  testFilter req.body.content
  user = req.user
  body = req.body
  data =
    content : body.content
    postBy  : user._id
    belongTo: body.belongTo
    type    : body.type
    tags    : body.tags

  console.log 'postBy type ', typeof data.postBy
  console.log 'belongTo', typeof data.belongTo

  userNameRe = /@(.*?)(?=\s|&nbsp|$)/g
  matchArray = null
  referUserNames = []
  while ((matchArray = userNameRe.exec(data.content)) != null)
    console.log 'Found user ' + matchArray[1]
    referUserNames.push(matchArray[1])

  referUserNames = _.uniq referUserNames
  console.log referUserNames

  Q.all _.map referUserNames, (userName)->
    User.findOneQ name: userName
  .then (referUsers)->
    referUsers = _.without referUsers, null
    _.forEach referUsers, (user)->
      re = new RegExp('@'+user.name, 'g')
      userLink = req.protocol+'://'+req.headers.host+'/users/'+user._id
      data.content = data.content.replace(re, "<a href=\"#{userLink}\">@#{user.name}</a>")

    WrapRequest.wrapCreate req, res, next, data

    Model = CommentUtils.getCommentRefByType body.type
    Q.all [
      Model.updateQ {_id: data.belongTo}, {$inc: {commentsNum: 1}} #TODO: add commentsNum to every Commented model ?
      CommentUtils.sendCommentNotices(data, referUsers)
    ]
    .catch next #TODO: remove catch when release?
    .done()


pickedUpdatedKeys = ['content', 'tags']
exports.update = (req, res, next) ->
  conditions = _id: req.params.id, postBy: req.user._id
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys


exports.destroy = (req, res, next) ->
  conditions = _id: req.params.id, postBy: req.user._id
  WrapRequest.wrapDestroy req, res, next, conditions


exports.like = WrapRequest.wrapLike.bind WrapRequest

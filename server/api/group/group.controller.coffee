'use strict'

Group = _u.getModel 'group'
WrapRequest = new (require '../../utils/WrapRequest')(Group)

exports.index = (req, res, next) ->
  conditions = {}
  conditions.creator = req.query.creator if req.query.creator
  conditions.featured = {'$ne':null} if req.query.featured

  if req.query.keyword
    keyword = new RegExp(_u.escapeRegex(req.query.keyword), 'i')
    conditions.$or = [
      name: keyword
    ,
      info: keyword
    ]
  WrapRequest.wrapPageIndex req, res, next, conditions

exports.show = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapShow req, res, next, conditions

exports.create = (req, res, next) ->
  pickedKeys = ['name', 'info','logo']
  if req.user.role is 'admin'
    pickedKeys.push 'featured'
  data = _.pick req.body, pickedKeys
  data.creator = req.user._id
  data.members = [req.user._id]
  WrapRequest.wrapCreate req, res, next, data

exports.update = (req, res, next) ->
  pickedUpdatedKeys = ['name', 'info', 'logo']
  if req.user.role is 'admin'
    pickedUpdatedKeys.push 'featured'
  conditions = {_id: req.params.id}
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys

exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapDestroy req, res, next, conditions

exports.joinOrLeave = (req, res, next) ->
  console.log req.url
  pattern = /(\w+)$/
  action = (pattern.exec req.url)[1]

  groupId = req.params.id
  user = req.user

  Group.findByIdQ groupId
  .then (group) ->
    switch action
      when 'join'
        if group.members.indexOf(user._id) > -1
          return Q.reject
            status: 400
            errCode: ErrCode.HasBeenHere
            errMsg: '你已经在这个组了'
        else
          group.members.addToSet user._id
          WrapRequest.addActivity(req.user.id, group, 'join')
      when 'leave'
        if group.members.indexOf(user._id) is -1
          return Q.reject
            status: 400
            errCode: ErrCode.HasNotBeenHere
            errMsg: '你不在这个房间'
        else
          group.members.pull user._id
      else
        return Q.reject
          status: 404
          errCode: ErrCode.IllegalPath
          errMsg: '非法路径'

    do group.saveQ
  .then (result) ->
    group = result[0]
    res.send group
  .catch next
  .done()


# TODO: paginate this!
exports.showMembers = (req, res, next) ->
  conditions = {_id: req.params.id}
  Group.findOne conditions
  .populate 'members', 'name avatar'
  .execQ()
  .then (doc) ->
    res.send doc.members
  .catch next
  .done()

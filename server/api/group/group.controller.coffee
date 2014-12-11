'use strict'

Group = _u.getModel 'group'
WrapRequest = new (require '../../utils/WrapRequest')(Group)

exports.index = WrapRequest.wrapIndex()

exports.show = WrapRequest.wrapCommonShow()

pickedKeys = ['title', 'description']
exports.create = WrapRequest.wrapCreate pickedKeys

pickedUpdatedKeys = ['title', 'description', 'avatar']
exports.update = WrapRequest.wrapUpdate pickedUpdatedKeys

exports.destroy = WrapRequest.wrapDestroy()

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
    group.populate 'creator', 'name avatar'
         .populateQ 'members', 'name avatar'
  .then (group) ->
    res.send group
  .catch next
  .done()

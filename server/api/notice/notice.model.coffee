'use strict'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require '../../common/BaseModel'

populateCommon = [
  path: 'fromWhom', select: 'avatar name'
,
  path: 'data.articleId', select: 'title group'
,
  path: 'data.courseId', select: 'title'
,
  path: 'data.commentId', select: 'content'
]

class Notice extends BaseModel
  populates:
    create: populateCommon
    index: populateCommon

  schema: new Schema
    userId:
      type: ObjectId
      ref: 'user'
      required: true
    fromWhom:
      type: ObjectId
      ref: 'user'
    type: Number #参考Const.NoticeType中的定义
    data:
      courseId:
        type: ObjectId
        ref: 'course'
      articleId :
        type : ObjectId
        ref : 'article'
      commentId:
        type : ObjectId
        ref : 'comment'
    status:
      type: Number #0: unread, 1: read
      default: 0

  removeByObjectId: (objectId) ->
    @removeQ {$or: [{'data.courseId': objectId}, {'data.articleId': objectId}, {'data.commentId': objectId}]}


exports.Class = Notice
exports.Instance = new Notice()

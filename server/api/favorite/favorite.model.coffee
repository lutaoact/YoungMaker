'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require '../../common/BaseModel'

class Favorite extends BaseModel
  schema: new Schema
    user:
      type: ObjectId
      ref: 'user'
      required: true
    object:
      type: ObjectId
      required: true
    type:
      type: Number # 1.Article 2.Course
      required: true

  constructor: () ->
    @schema.index {user: 1, object: 1}, {unique: true}
    @schema.index {user: 1, type: 1}

    super

  getByUserAndObject: (userId, objectId) ->
    return @findOneQ {user: userId, object: objectId}

exports.Class = Favorite
exports.Instance = new Favorite()

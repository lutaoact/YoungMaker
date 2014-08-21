'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
BaseModel = (require '../../common/BaseModel').BaseModel

exports.Thing = BaseModel.subclass
  classname: 'Thing'
  initialize: ($super) ->
    @schema = new Schema
      name: String
      info: String
      active: Boolean

    $super()

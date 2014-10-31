require './init'
mongoose = null
models = {}
createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin

class BaseModel
  classname : 'BaseModel'
  model     : null
  mongoose  : null
  schema    : null
  dbURL     : ''



module.exports = BaseModel

require './init'
mongoose = null
models = {}
createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin

class BaseModel
  model     : null
  mongoose  : null
  schema    : null
  dbURL     : ''

  constructor: () ->
    if _.isEmpty mongoose
      mongoose = require('mongoose-q')(null, {spread: true})
      dbURL = @dbURL || config.mongo.uri
      connection = mongoose.connect(dbURL, config.mongo.options).connection

      connection.on 'error', (err) ->
          console.log('connection error:' + err)

      connection.once 'open', () ->
          console.log('open mongodb success')

    @mongoose = mongoose

    if @schema?
      @createModel _u.convertToSnakeCase @constructor.name


  createModel : (name) ->
    @schema.plugin createdModifiedPlugin, {index: true}

    unless models[name]?
      models[name] = mongoose.model name, @schema

    @model = models[name]


methods = [
    # mongoose.Model static
    'remove', 'ensureIndexes', 'find', 'findById', 'findOne', 'count', 'distinct',
    'findOneAndUpdate', 'findByIdAndUpdate', 'findOneAndRemove', 'findByIdAndRemove',
    'create', 'update', 'mapReduce', 'aggregate', 'populate',
    'geoNear', 'geoSearch',
    # mongoose.Document static
    'update'
]
_.each methods, (method) ->
  BaseModel::[method] = () ->
    @model[method].apply @model, arguments

  methodQ = method + 'Q'
  BaseModel::[methodQ] = () ->
    @model[methodQ].apply @model, arguments

module.exports = BaseModel

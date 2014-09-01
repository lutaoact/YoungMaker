
# Populate DB with sample data on server start
# to disable, edit config/environment/index.js, and set `seedDB: false`

'use strict'
require '../common/init'

removeAndCreate = (name, data) ->
  Model = _u.getModel name

  Model.removeQ {}
  .then () ->
    Model.createQ data
  .then (docs) ->
    return docs
  , (err) ->
    Q.reject err

module.exports = (seedData) ->
  actions = (removeAndCreate name, data for name, data of seedData)

  Q.all actions
  .then (results) ->
    logger.info results
    console.log 'success'
  , (err) ->
    console.log err

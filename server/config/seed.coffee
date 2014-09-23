
# Populate DB with sample data on server start
# to disable, edit config/environment/index.js, and set `seedDB: false`

'use strict'
require '../common/init'

removeAndCreate = (name, data) ->
  Model = _u.getModel name

  ids = _.pluck data, '_id'
  condition = {}
  condition._id = $in: ids if _.compact(ids).length > 0

  Model.removeQ condition
  .then () ->
    Model.createQ data
  .then (docs) ->
    return docs

module.exports = (seedData) ->
  actions = (removeAndCreate name, data for name, data of seedData)

  Q.all actions
  .then (results) ->
#    logger.info results
    console.log 'load data success'
  , (err) ->
    console.log err

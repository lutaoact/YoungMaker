
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /classe              ->  index
# * POST    /classe              ->  create
# * GET     /classe/:id          ->  show
# * PUT     /classe/:id          ->  update
# * PATCH   /classe/:id          ->  update
# * DELETE  /classe/:id          ->  destroy
# * POST    /classe/multiDelete  ->  destroy
#
"use strict"

Classe = _u.getModel "classe"

exports.index = (req, res, next) ->
  user = req.user
  Classe.findQ
    orgId: user.orgId
  .then (classes) ->
    res.send classes
  , next

exports.show = (req, res, next) ->
  user = req.user
  classeId = req.params.id
  Classe.findOneQ
    _id: classeId
    orgId: user.orgId
  .then (classe) ->
    logger.info classe
    res.send classe
  , (err) ->
    console.log err
    next err

exports.showStudents = (req, res, next) ->
  user = req.user
  classeId = req.params.id

  Classe.findOne
    _id: classeId
    orgId: user.orgId
  .populate 'students'
  .execQ()
  .then (classe) ->
    res.send classe.students
  , next

exports.create = (req, res, next) ->
  body = req.body
  body.orgId = req.user.orgId

  Classe.createQ body
  .then (classe) ->
    logger.info classe
    res.json 201, classe
  , next

exports.update = (req, res, next) ->
  classeId = req.params.id
  body = req.body
  delete body._id if body._id

  Classe.findByIdQ classeId
  .then (classe) ->
    updated = _.extend classe, body
    do updated.saveQ
  .then (result) ->
    newClasse = result[0]
    logger.info newClasse
    res.send newClasse
  , next

exports.destroy = (req, res, next) ->
  classeId = req.params.id
  Classe.removeQ
    _id: classeId
  .then () ->
    res.send 204
  , next

exports.multiDelete = (req, res, next) ->
  ids = req.body.ids
  Classe.removeQ
    _id: $in: ids
  .then () ->
    res.send 204
  , next

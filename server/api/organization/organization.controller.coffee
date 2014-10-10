
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /organizations              ->  index
# * GET     /organizations{?sub}        ->  get by subdomain
# * POST    /organizations              ->  create
# * GET     /organizations/:id          ->  show
# * PUT     /organizations/:id          ->  update
# * DELETE  /organizations/:id          ->  destroy
#
"use strict"

Organization = _u.getModel "organization"
User = _u.getModel "user"

exports.index = (req, res, next) ->
  Organization.findQ {}
  .then (organizations) ->
    res.send organizations
  , (err) ->
    next err

exports.me = (req, res, next) ->
  orgId = req.user.orgId
  console.log req.user
  Organization.findOneQ
    _id: orgId
  .then (organization) ->
    res.send organization
  , (err) ->
    next err

exports.show = (req, res, next) ->
  orgId = req.params.id
  Organization.findByIdQ orgId
  .then (organization) ->
    res.send organization
  , (err) ->
    next err

exports.create = (req, res, next) ->
  body = req.body
  Organization.createQ body
  .then (organization) ->
    res.send 201, organization
  , (err) ->
    next err

exports.update = (req, res, next) ->
  orgId = req.params.id
  body = req.body
  delete body._id
  delete body.uniqueName

  (if orgId.toString() isnt req.user.orgId.toString()
    Q.reject
      status : 403
      errCode : ErrCode.NotAdminForOrg
      errMsg : 'You are not admin for this organization'
  else
    Organization.findByIdQ orgId
  ).then (organization) ->
    updated = _.extend organization, body
    do updated.saveQ
  .then (result) ->
    newValue = result[0]
    res.send newValue
  , (err) ->
    next err

exports.destroy = (req, res, next) ->
  orgId = req.params.id
  Organization.removeQ
    _id: orgId
  .then () ->
    res.send 204
  , (err) ->
    next err

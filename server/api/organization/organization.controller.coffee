
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

_ = require("lodash")
Organization = require("./organization.model")
User = require("../user/user.model")

exports.index = (req, res) ->
  resFun = (err, organizations) ->
    return handleError(res, err)  if err
    res.json 200, organizations

  subDomain = req.query.sub
  if subDomain
    Organization.find
      subDomain: subDomain
    , resFun
  else
    Organization.find resFun


exports.me = (req, res) ->
  userId = req.user.id
  User.findOne(_id: userId).populate("orgId").exec (err, user) ->
    return handleError(res, err)  if err
    res.json 200, user.orgId


exports.show = (req, res) ->
  Organization.findById req.params.id, (err, organization) ->
    return handleError(res, err)  if err
    return res.send(404)  unless organization
    res.json organization


exports.create = (req, res) ->
  Organization.create req.body, (err, organization) ->
    return handleError(res, err)  if err
    User.findById req.user.id, (err, user) ->
      return handleError(res, err)  if err
      user.orgId = organization._id
      user.save (err) ->
        return handleError(res, err)  if err
        res.json 201, organization


exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Organization.findById req.params.id, (err, organization) ->
    return handleError(err)  if err
    return res.send(404)  unless Organization
    updated = _.merge(organization, req.body)
    updated.save (err) ->
      return handleError(err)  if err
      res.json 200, organization


exports.destroy = (req, res) ->
  Organization.findById req.params.id, (err, organization) ->
    return handleError(res, err)  if err
    return res.send(404)  unless organization
    organization.remove (err) ->
      return handleError(res, err)  if err
      res.send 204


handleError = (res, err) ->
  res.send 500, err


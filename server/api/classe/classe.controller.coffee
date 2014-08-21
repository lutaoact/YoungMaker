
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /classe              ->  index
# * POST    /classe              ->  create
# * GET     /classe/:id          ->  show
# * PUT     /classe/:id          ->  update
# * DELETE  /classe/:id          ->  destroy
#
"use strict"

_ = require("lodash")
Classe = require("./classe.model")
User = require("../user/user.model")

exports.index = (req, res) ->
  User.findOne(_id: req.user.id).exec (err, user) ->
    return handleError(res, err)  if err
    Classe.find(orgId: user.orgId).select("_id name orgId yearGrade modified created").exec (err, classes) ->
      return handleError(res, err)  if err
      res.json 200, classes


exports.show = (req, res) ->
  User.findOne(_id: req.user.id).exec (err, user) ->
    return handleError(res, err)  if err
    Classe.findById(req.params.id).where("orgId").equals(user.orgId).exec (err, classe) ->
      return handleError(res, err)  if err
      res.json 200, classe


exports.showStudents = (req, res) ->
  User.findOne(_id: req.user.id).exec (err, user) ->
    return handleError(res, err)  if err
    Classe.findById(req.params.id).where("orgId").equals(user.orgId).populate(
      path: "students"
      select: "_id name email orgId avatar status"
    ).exec (err, classe) ->
      return handleError(res, err)  if err
      console.dir classe
      res.json 200, classe.students


exports.create = (req, res) ->
  req.body.orgId = req.user.orgId
  Classe.create req.body, (err, classe) ->
    return handleError(res, err)  if err
    res.json 201, classe


exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Classe.findById req.params.id, (err, classe) ->
    return handleError(err)  if err
    return res.send(404)  unless classe
    updated = _.extend(classe, req.body)
    updated.save (err) ->
      return handleError(err)  if err
      res.json 200, classe


exports.destroy = (req, res) ->
  Classe.findById req.params.id, (err, classe) ->
    return handleError(res, err)  if err
    return res.send(404)  unless classe
    classe.remove (err) ->
      return handleError(res, err)  if err
      res.send 204


handleError = (res, err) ->
  res.send 500, err

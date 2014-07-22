
/*
 * Using Rails-like standard naming convention for endpoints.
 * GET     /classe              ->  index
 * POST    /classe              ->  create
 * GET     /classe/:id          ->  show
 * PUT     /classe/:id          ->  update
 * DELETE  /classe/:id          ->  destroy
 */

(function() {
  'use strict';
  var Classe, User, handleError, _;

  _ = require('lodash');

  Classe = require('./classe.model');
  User = require('../user/user.model');

  exports.index = function(req, res) {
    User
    .findOne({_id: req.user.id})
    .exec(function(err, user) {
      if (err) return handleError(res, err);
      Classe
      .find({orgId: user.orgId})
      .select('_id name orgId yearGrade modified created')
      .exec(function(err, classes){
        if (err) return handleError(res, err);
        return res.json(200, classes)
      });
    });
  };

  exports.show = function(req, res) {
    User
    .findOne({_id: req.user.id})
    .exec(function(err, user) {
      if (err) return handleError(res, err);
      Classe
      .findById(req.params.id)
      .where('orgId').equals(user.orgId)
      .exec(function(err, classe){
        if (err) return handleError(res, err);
        return res.json(200, classe)
      });
    });
  };

  exports.create = function(req, res) {
    req.body.orgId = req.user.orgId;
    return Classe.create(req.body, function(err, classe) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(201, classe);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return Classe.findById(req.params.id, function(err, classe) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!classe) {
        return res.send(404);
      }
      updated = _.merge(classe, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, classe);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Classe.findById(req.params.id, function(err, classe) {
      if (err) {
        return handleError(res, err);
      }
      if (!classe) {
        return res.send(404);
      }
      return classe.remove(function(err) {
        if (err) {
          return handleError(res, err);
        }
        return res.send(204);
      });
    });
  };

  handleError = function(res, err) {
    return res.send(500, err);
  };

}).call(this);

//# sourceMappingURL=classe.controller.js.map

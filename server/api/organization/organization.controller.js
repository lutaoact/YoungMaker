
/*
 * Using Rails-like standard naming convention for endpoints.
 * GET     /organization             ->  index
 * POST    /organization              ->  create
 * GET     /organization/:id          ->  show
 * PUT     /organization/:id          ->  update
 * DELETE  /organization/:id          ->  destroy
 */

(function() {
  'use strict';
  var Organization, User, handleError, _;

  _ = require('lodash');

  Organization = require('./organization.model');
  User = require('../user/user.model');

  exports.me = function(req, res) {
    var userId, orgId;
    userId = req.user.id;
    User
    .findOne({_id: userId})
    .populate('org_id')
    .exec(function (err, user) {
      if (err) return handleError(res, err);
      return res.json(200, user.org_id)
    })
  };

  exports.show = function(req, res) {
    return Organization.findById(req.params.id, function(err, organization) {
      if (err) {
        return handleError(res, err);
      }
      if (!organization) {
        return res.send(404);
      }
      return res.json(organization);
    });
  };

  exports.create = function(req, res) {
    return Organization.create(req.body, function(err, organization) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(201, organization);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return Organization.findById(req.params.id, function(err, organization) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!Organization) {
        return res.send(404);
      }
      updated = _.merge(organization, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, organization);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Organization.findById(req.params.id, function(err, organization) {
      if (err) {
        return handleError(res, err);
      }
      if (!organization) {
        return res.send(404);
      }
      return organization.remove(function(err) {
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

//# sourceMappingURL=Organization.controller.js.map

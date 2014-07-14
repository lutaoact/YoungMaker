
/*
 * Using Rails-like standard naming convention for endpoints.
 * GET     /things              ->  index
 * POST    /things              ->  create
 * GET     /things/:id          ->  show
 * PUT     /things/:id          ->  update
 * DELETE  /things/:id          ->  destroy
 */

(function() {
  'use strict';
  var Thing, handleError, _;

  _ = require('lodash');

  Thing = require('./thing.model');

  exports.index = function(req, res) {
    return Thing.find(function(err, things) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, things);
    });
  };

  exports.show = function(req, res) {
    return Thing.findById(req.params.id, function(err, thing) {
      if (err) {
        return handleError(res, err);
      }
      if (!thing) {
        return res.send(404);
      }
      return res.json(thing);
    });
  };

  exports.create = function(req, res) {
    return Thing.create(req.body, function(err, thing) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(201, thing);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return Thing.findById(req.params.id, function(err, thing) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!thing) {
        return res.send(404);
      }
      updated = _.merge(thing, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, thing);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Thing.findById(req.params.id, function(err, thing) {
      if (err) {
        return handleError(res, err);
      }
      if (!thing) {
        return res.send(404);
      }
      return thing.remove(function(err) {
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

//# sourceMappingURL=thing.controller.js.map

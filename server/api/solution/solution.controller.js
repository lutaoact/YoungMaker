
/*
 * Using Rails-like standard naming convention for endpoints.
 * GET     /solutions              ->  index
 * POST    /solutions              ->  create
 * GET     /solutions/:id          ->  show
 * PUT     /solutions/:id          ->  update
 * DELETE  /solutions/:id          ->  destroy
 */

(function() {
  'use strict';
  var Solution, handleError, _;

  _ = require('lodash');

  Solution = _u.getModel("solution");

  exports.index = function(req, res) {
    return Solution.find(function(err, solutions) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, solutions);
    });
  };

  exports.show = function(req, res) {
    return Solution.findById(req.params.id, function(err, solution) {
      if (err) {
        return handleError(res, err);
      }
      if (!solution) {
        return res.send(404);
      }
      return res.json(solution);
    });
  };

  exports.create = function(req, res) {
    return Solution.create(req.body, function(err, solution) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(201, solution);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return Solution.findById(req.params.id, function(err, solution) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!solution) {
        return res.send(404);
      }
      updated = _.merge(solution, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, solution);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Solution.findById(req.params.id, function(err, solution) {
      if (err) {
        return handleError(res, err);
      }
      if (!solution) {
        return res.send(404);
      }
      return solution.remove(function(err) {
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

//# sourceMappingURL=Solution.controller.js.map

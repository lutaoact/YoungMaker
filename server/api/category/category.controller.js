
/*
 * Using Rails-like standard naming convention for endpoints.
 * GET     /categories              ->  index
 * POST    /categories              ->  create
 * GET     /categories/:id          ->  show
 * PUT     /categories/:id          ->  update
 * DELETE  /categories/:id          ->  destroy
 */

(function() {
  'use strict';
  var Category, handleError, _;

  _ = require('lodash');

  Category = require('./category.model');

  exports.index = function(req, res) {
    return Category.find(function(err, categories) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, categories);
    });
  };

  exports.show = function(req, res) {
    return Category.findById(req.params.id, function(err, category) {
      if (err) {
        return handleError(res, err);
      }
      if (!category) {
        return res.send(404);
      }
      return res.json(category);
    });
  };

  exports.create = function(req, res) {
    return Category.create(req.body, function(err, category) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(201, category);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return Category.findById(req.params.id, function(err, category) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!category) {
        return res.send(404);
      }
      updated = _.merge(category, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, category);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Category.findById(req.params.id, function(err, category) {
      if (err) {
        return handleError(res, err);
      }
      if (!category) {
        return res.send(404);
      }
      return category.remove(function(err) {
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

//# sourceMappingURL=Category.controller.js.map

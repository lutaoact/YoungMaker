
/*
 * Using Rails-like standard naming convention for endpoints.
 * GET     /knowledge_points              ->  index
 * POST    /knowledge_points              ->  create
 * GET     /knowledge_points/:id          ->  show
 * PUT     /knowledge_points/:id          ->  update
 * DELETE  /knowledge_points/:id          ->  destroy
 */

(function() {
  'use strict';
  var KnowledgePoint, Lecture, handleError, _;

  _ = require('lodash');

  KnowledgePoint = require('./knowledge_point.model');
  Lecture = require('../lecture/lecture.model');

  exports.index = function(req, res) {
    var conditions = {};
    if (req.query.categoryId) {
      conditions = {categoryId: req.query.categoryId}
    }
    return KnowledgePoint.find(conditions, function(err, categories) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, categories);
    });
  };

  exports.show = function(req, res) {
    return KnowledgePoint.findById(req.params.id, function(err, knowledgePoint) {
      if (err) {
        return handleError(res, err);
      }
      if (!knowledgePoint) {
        return res.send(404);
      }
      return res.json(knowledgePoint);
    });
  };

  exports.create = function(req, res) {
    return KnowledgePoint.create(req.body, function(err, knowledgePoint) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(201, knowledgePoint);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return KnowledgePoint.findById(req.params.id, function(err, knowledgePoint) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!knowledgePoint) {
        return res.send(404);
      }
      updated = _.merge(knowledgePoint, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, knowledgePoint);
      });
    });
  };

  exports.destroy = function(req, res) {
    Lecture.find({knowledgePoints: req.params.id},function(err, lectures){
      if (err) return handleError(res, err);
      // forbid deleting if it is referenced by Lecture
      if (lectures.length != 0) {
        // console.log(lectures);
        return res.send(400);
      }
      else {
        KnowledgePoint.findById(req.params.id, function(err, knowledgePoint) {
          if (err) {
            return handleError(res, err);
          }
          if (!knowledgePoint) {
            return res.send(404);
          }
          return knowledgePoint.remove(function(err) {
            if (err) {
              return handleError(res, err);
            }
            return res.send(204);
          });
        });
      }
    });
  };

  handleError = function(res, err) {
    return res.send(500, err);
  };

}).call(this);

//# sourceMappingURL=KnowledgePoint.controller.js.map

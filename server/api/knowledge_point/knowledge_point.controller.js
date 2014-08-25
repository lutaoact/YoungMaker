(function() {
  "use strict";
  var KnowledgePoint, Lecture, handleError, _;

  _ = require("lodash");

  KnowledgePoint = _u.getModel("knowledge_point");

  Lecture = _u.getModel("lecture");

  exports.index = function(req, res) {
    var conditions;
    conditions = {};
    if (req.query.categoryId) {
      conditions = {
        categoryId: req.query.categoryId
      };
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
      updated = _.extend(knowledgePoint, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, knowledgePoint);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Lecture.find({
      knowledgePoints: req.params.id
    }, function(err, lectures) {
      if (err) {
        return handleError(res, err);
      }
      if (lectures.length !== 0) {
        return res.send(400);
      } else {
        return KnowledgePoint.findById(req.params.id, function(err, knowledgePoint) {
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


  /* copied from course controller, need to implement these logic in above methods
  
     * insert knowledgePoint id to this Lecture; create a knowledgePoint when _id is not provided
  exports.createKnowledgePoint = (req, res) ->
    updateLectureKnowledgePoints = (knowledgePoint) ->
      Lecture.findByIdAndUpdate req.params.lectureId,
        $push:
          knowledgePoints: knowledgePoint._id
      , (err, lecture) ->
        return handleError(res, err)  if err
        res.send knowledgePoint
  
    Course.findOne(
      _id: req.params.id
      owners:
        $in: [req.user.id]
    ).exec (err, course) ->
      return handleError(res, err)  if err
      return res.send(404)  unless course
      if req.body._id # TODO: validate this _id!
        updateLectureKnowledgePoints req.body
      else
        KnowledgePoint.create req.body, (err, knowledgePoint) ->
          return handleError(err)  if err
          updateLectureKnowledgePoints knowledgePoint
  
  
  exports.showKnowledgePoints = (req, res) ->
    Lecture.findById(req.params.lectureId).populate("knowledgePoints").exec (err, lecture) ->
      return handleError(res, err)  if err
      return res.send(404)  unless lecture
      res.json lecture.knowledgePoints
   */

  handleError = function(res, err) {
    return res.send(500, err);
  };

}).call(this);

//# sourceMappingURL=knowledge_point.controller.js.map

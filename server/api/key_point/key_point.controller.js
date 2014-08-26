(function() {
  "use strict";
  var KeyPoint, Lecture, handleError, _;

  _ = require("lodash");

  KeyPoint = _u.getModel("key_point");

  Lecture = _u.getModel("lecture");

  exports.index = function(req, res) {
    var conditions;
    conditions = {};
    if (req.query.categoryId) {
      conditions = {
        categoryId: req.query.categoryId
      };
    }
    return KeyPoint.find(conditions, function(err, categories) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, categories);
    });
  };

  exports.show = function(req, res) {
    return KeyPoint.findById(req.params.id, function(err, keyPoint) {
      if (err) {
        return handleError(res, err);
      }
      if (!keyPoint) {
        return res.send(404);
      }
      return res.json(keyPoint);
    });
  };

  exports.create = function(req, res) {
    return KeyPoint.create(req.body, function(err, keyPoint) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(201, keyPoint);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return KeyPoint.findById(req.params.id, function(err, keyPoint) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!keyPoint) {
        return res.send(404);
      }
      updated = _.extend(keyPoint, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, keyPoint);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Lecture.find({
      keyPoints: req.params.id
    }, function(err, lectures) {
      if (err) {
        return handleError(res, err);
      }
      if (lectures.length !== 0) {
        return res.send(400);
      } else {
        return KeyPoint.findById(req.params.id, function(err, keyPoint) {
          if (err) {
            return handleError(res, err);
          }
          if (!keyPoint) {
            return res.send(404);
          }
          return keyPoint.remove(function(err) {
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
  
     * insert keyPoint id to this Lecture; create a keyPoint when _id is not provided
  exports.createKeyPoint = (req, res) ->
    updateLectureKeyPoints = (keyPoint) ->
      Lecture.findByIdAndUpdate req.params.lectureId,
        $push:
          keyPoints: keyPoint._id
      , (err, lecture) ->
        return handleError(res, err)  if err
        res.send keyPoint
  
    Course.findOne(
      _id: req.params.id
      owners:
        $in: [req.user.id]
    ).exec (err, course) ->
      return handleError(res, err)  if err
      return res.send(404)  unless course
      if req.body._id # TODO: validate this _id!
        updateLectureKeyPoints req.body
      else
        KeyPoint.create req.body, (err, keyPoint) ->
          return handleError(err)  if err
          updateLectureKeyPoints keyPoint
  
  
  exports.showKeyPoints = (req, res) ->
    Lecture.findById(req.params.lectureId).populate("keyPoints").exec (err, lecture) ->
      return handleError(res, err)  if err
      return res.send(404)  unless lecture
      res.json lecture.keyPoints
   */

  handleError = function(res, err) {
    return res.send(500, err);
  };

}).call(this);

//# sourceMappingURL=key_point.controller.js.map

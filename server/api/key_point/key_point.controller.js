(function() {
  "use strict";
  var KeyPoint, Lecture;

  KeyPoint = _u.getModel("key_point");

  Lecture = _u.getModel("lecture");

  exports.index = function(req, res, next) {
    var conditions;
    conditions = {};
    if (req.query.categoryId) {
      conditions.categoryId = req.query.categoryId;
    }
    return KeyPoint.findQ(conditions).then(function(keyPoints) {
      return res.send(keyPoints);
    }, function(err) {
      return next(err);
    });
  };

  exports.show = function(req, res, next) {
    return KeyPoint.findByIdQ(req.params.id).then(function(keyPoint) {
      return res.send(keyPoint);
    }, function(err) {
      return next(err);
    });
  };

  exports.create = function(req, res, next) {
    return KeyPoint.createQ(req.body).then(function(keyPoint) {
      return res.send(201, keyPoint);
    }, function(err) {
      return next(err);
    });
  };

  exports.searchByKeyword = function(req, res, next) {
    var escape, name, regex;
    name = req.params.name;
    escape = name.replace(/[{}()^$|.\[\]*?+]/g, '\\$&');
    regex = new RegExp(escape);
    logger.info(regex);
    return KeyPoint.findQ({
      name: regex
    }).then(function(keyPoints) {
      return res.send(keyPoints);
    }, function(err) {
      return next(err);
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

}).call(this);

//# sourceMappingURL=key_point.controller.js.map

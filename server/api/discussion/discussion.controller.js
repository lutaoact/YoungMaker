
/*
 * Using Rails-like standard naming convention for endpoints.
 * GET     /discussions              ->  index
 * POST    /discussions              ->  create
 * GET     /discussions/:id          ->  show
 * PUT     /discussions/:id          ->  update
 * DELETE  /discussions/:id          ->  destroy
 */

(function() {
  'use strict';
  var Discussion, handleError, withUserInfo;

  Discussion = ['discussion'];

  exports.index = function(req, res) {
    var from, limit, _ref;
    from = (_ref = req.query.from) != null ? _ref : 0;
    if (!req.query.limit || req.query.limit > 128) {
      limit = 36;
    } else {
      limit = req.query.limit;
    }
    return Discussion.find({
      'courseId': req.params.courseId
    }).lean().populate('userId', "_id name avatar").sort({
      'created': -1
    }).limit(limit).skip(from).exec(function(err, discussions) {
      if (err) {
        return handleError(res, err);
      }
      discussions.forEach(function(disc) {
        return withUserInfo(disc, disc.userId);
      });
      return res.json(200, discussions);
    });
  };

  exports.show = function(req, res) {
    return Discussion.findById(req.params.id, function(err, discussion) {
      if (err) {
        return handleError(res, err);
      }
      if (!discussion) {
        return res.send(404);
      }
      return res.json(discussion);
    });
  };

  exports.create = function(req, res) {
    if (req.body.voteUpUsers) {
      delete req.body.voteUpUsers;
    }
    req.body.userId = req.user.id;
    req.body.courseId = req.params.courseId;
    return Discussion.create(req.body, function(err, discussion) {
      var discWithUserInfo;
      if (err) {
        return handleError(res, err);
      }
      discWithUserInfo = withUserInfo(discussion.toObject(), req.user);
      return res.json(201, discWithUserInfo);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    if (req.body.responseTo) {
      delete req.body.responseTo;
    }
    if (req.body.voteUpUsers) {
      delete req.body.voteUpUsers;
    }
    return Discussion.findOne({
      '_id': req.params.id,
      'userId': req.user.id
    }, function(err, discussion) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!discussion) {
        return res.send(404);
      }
      updated = _.merge(discussion, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, discussion);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Discussion.findOne({
      '_id': req.params.id,
      'userId': req.user.id
    }, function(err, discussion) {
      if (err) {
        return handleError(res, err);
      }
      if (!discussion) {
        return res.send(404);
      }
      return discussion.remove(function(err) {
        if (err) {
          return handleError(res, err);
        }
        return res.send(204);
      });
    });
  };

  exports.vote = function(req, res) {
    var userId;
    userId = req.user.id;
    return Discussion.findById(req.params.id, function(err, disc) {
      var downIdx, upIdx;
      if (err) {
        return handleError(res, err);
      }
      if (!disc) {
        return res.send(403);
      }
      if (req.body.vote === '1') {
        upIdx = disc.voteUpUsers.indexOf(userId);
        if (upIdx === -1) {
          disc.voteUpUsers.push(userId);
          downIdx = disc.voteDownUsers.indexOf(userId);
          if (downIdx !== -1) {
            disc.voteDownUsers.splice(downIdx, 1);
            disc.markModified('voteDownUsers');
          }
        } else {
          disc.voteUpUsers.splice(upIdx, 1);
        }
        disc.markModified('voteUpUsers');
        disc.save();
      } else if (req.body.vote === '-1') {
        downIdx = disc.voteDownUsers.indexOf(userId);
        if (downIdx === -1) {
          disc.voteDownUsers.push(userId);
          upIdx = disc.voteUpUsers.indexOf(userId);
          if (upIdx !== -1) {
            disc.voteUpUsers.splice(upIdx, 1);
            disc.markModified('voteUpUsers');
          }
        } else {
          disc.voteDownUsers.splice(downIdx, 1);
        }
        disc.markModified('voteDownUsers');
        disc.save();
      }
      return res.json(200, disc);
    });
  };

  withUserInfo = function(disc, user) {
    delete disc.userId;
    disc.user = {
      _id: user._id,
      avatar: user.avatar,
      name: user.name
    };
    return disc;
  };

  handleError = function(res, err) {
    return res.send(500, err);
  };

}).call(this);

//# sourceMappingURL=discussion.controller.js.map

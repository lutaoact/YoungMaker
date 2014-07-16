(function() {
  'use strict';
  var User, config, jwt, passport, validationError;

  User = require('./user.model');

  passport = require('passport');

  config = require('../../config/environment');

  jwt = require('jsonwebtoken');

  validationError = function(res, err) {
    return res.json(422, err);
  };


  /*
    Get list of users
    restriction: 'admin'
   */

  exports.index = function(req, res) {
    return User.find({}, '-salt -hashedPassword', function(err, users) {
      if (err) {
        res.send(500, err);
      }
      return res.json(200, users);
    });
  };


  /*
    Creates a new user
   */

  exports.create = function(req, res, next) {
    var newUser;
    newUser = new User(req.body);
    newUser.provider = 'local';
    return newUser.save(function(err, user) {
      var token;
      if (err) {
        validationError(res, err);
      }
      token = jwt.sign({
        _id: user._id
      }, config.secrets.session, {
        expiresInMinutes: 60 * 5
      });
      return res.json({
        token: token
      });
    });
  };


  /*
    Get a single user
   */

  exports.show = function(req, res, next) {
    var userId;
    userId = req.params.id;
    return User.findById(userId, function(err, user) {
      if (err) {
        next(err);
      }
      if (!user) {
        res.send(401);
      }
      return res.json(user.profile);
    });
  };


  /*
    Deletes a user
    restriction: 'admin'
   */

  exports.destroy = function(req, res) {
    return User.findByIdAndRemove(req.params.id, function(err, user) {
      if (err) {
        res.send(500, err);
      }
      return res.send(204);
    });
  };


  /*
    Change a users password
   */

  exports.changePassword = function(req, res, next) {
    var newPass, oldPass, userId;
    userId = req.user._id;
    oldPass = String(req.body.oldPassword);
    newPass = String(req.body.newPassword);
    return User.findById(userId, function(err, user) {
      if (user.authenticate(oldPass)) {
        user.password = newPass;
        return user.save(function(err) {
          if (err) {
            validationError(res, err);
          }
          return res.send(200);
        });
      } else {
        return res.send(403);
      }
    });
  };


  /*
    Get my info
   */

  exports.me = function(req, res, next) {
    var userId;
    userId = req.user._id;
    return User.findOne({
      _id: userId
    }, '-salt -hashedPassword', function(err, user) {
      if (err) {
        next(err);
      }
      if (!user) {
        res.json(401);
      }
      return res.json(user);
    });
  };


  /*
   Authentication callback
   */

  exports.authCallback = function(req, res, next) {
    return res.redirect('/');
  };

}).call(this);

//# sourceMappingURL=user.controller.js.map

(function() {
  'use strict';
  var User, config, helpers, jwt, passport, path, processExcel, qiniu, qiniuDomain, validationError;

  User = require('./user.model');

  passport = require('passport');

  config = require('../../config/environment');

  jwt = require('jsonwebtoken');

  qiniu = require('qiniu');

  helpers = require('../../common/helpers');

  path = require('path');

  qiniu.conf.ACCESS_KEY = config.qiniu.access_key;

  qiniu.conf.SECRET_KEY = config.qiniu.secret_key;

  qiniuDomain = config.qiniu.domain;

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
        return validationError(res, err);
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

  processExcel = function(file) {
    return console.log('start processing excel file ...');
  };


  /*
    Bulk import users from excel sheet uploaded by client
   */

  exports.bulkImport = function(req, res, next) {
    var baseUrl, destFile, policy, resourceKey, tempUrl;
    resourceKey = req.body.url;
    baseUrl = qiniu.rs.makeBaseUrl(qiniuDomain, resourceKey);
    policy = new qiniu.rs.GetPolicy();
    tempUrl = policy.makeRequest(baseUrl);
    destFile = config.tmpDir + path.sep + 'user_list.xls';
    console.log('tempUrl is ' + tempUrl);
    console.log('destDir is ' + destFile);
    return helpers.downloadFile(tempUrl, destFile, processExcel);
  };


  /*
   Authentication callback
   */

  exports.authCallback = function(req, res, next) {
    return res.redirect('/');
  };

}).call(this);

//# sourceMappingURL=user.controller.js.map

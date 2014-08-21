(function() {
  'use strict';
  var User, UserStat, config, fs, helpers, http, jwt, passport, path, qiniu, qiniuDomain, updateClasseStudents, xlsx, _;

  User = modelMap["user"];

  passport = require('passport');

  config = require('../../config/environment');

  jwt = require('jsonwebtoken');

  qiniu = require('qiniu');

  helpers = require('../../common/helpers');

  path = require('path');

  _ = require('lodash');

  fs = require('fs');

  http = require('http');

  xlsx = require('node-xlsx');

  UserStat = modelMap["user_stat"];

  qiniu.conf.ACCESS_KEY = config.qiniu.access_key;

  qiniu.conf.SECRET_KEY = config.qiniu.secret_key;

  qiniuDomain = config.qiniu.domain;


  /*
    Get list of users
    restriction: 'admin'
   */

  exports.index = function(req, res) {
    return User.find({}, '-salt -hashedPassword', function(err, users) {
      if (err) {
        return res.send(500, err);
      }
      return res.json(200, users);
    });
  };


  /*
    Creates a new user
   */

  exports.create = function(req, res) {
    var body;
    body = req.body;
    body.provider = 'local';
    return User.create(body, function(err, user) {
      var token;
      if (err) {
        return helpers.validationError(res, err);
      }
      UserStat.create({
        "userId": user._id
      });
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
        return res.send(401);
      }
      return res.json(user.profile);
    });
  };


  /*
    Get a single user by email
   */

  exports.showByEmail = function(req, res) {
    return User.findOne({
      'email': req.params.email
    }, function(err, user) {
      if (err) {
        helpers.handleError;
      }
      if (!user) {
        return res.send(404);
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
        return res.send(500, err);
      }
      return res.send(200, user);
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
            return helpers.validationError(res, err);
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
    User.findOne({
      _id: userId
    }, '-salt -hashedPassword');
    return function(err, user) {
      if (err) {
        next(err);
      }
      if (!user) {
        return res.json(401);
      }
      return res.json(user);
    };
  };


  /*
    Update user
   */

  exports.update = function(req, res) {
    if (_.has(req.body, '_id')) {
      delete req.body._id;
    }
    if (_.has(req.body, 'password')) {
      delete req.body.password;
    }
    return User.findById(req.params.id, function(err, user) {
      var updated;
      if (err) {
        return helpers.handleError(res, err);
      }
      if (!user) {
        return res.send(404);
      }
      updated = _.merge(user, req.body);
      return updated.save(function(err) {
        if (err) {
          return helpers.handleError(res, err);
        }
        return res.json(200, user);
      });
    });
  };

  updateClasseStudents = function(res, classeId, studentList, importReport) {
    return Classe.findById(classeId, function(err, classe) {
      if (err) {
        return helpers.handleError(res, err);
      }
      if (!classe) {
        return res.send(404);
      }
      console.log('Found classe with id ');
      console.dir(classe);
      classe.students = _.merge(classe.students, studentList);
      classe.markModified('students');
      console.log('After merge...');
      console.dir(classe);
      return classe.save(function(err, saved) {
        if (err) {
          return helpers.handleError(res, err);
        }
        console.log('After save...');
        console.dir(saved);
        return res.json(200, importReport);
      });
    });
  };


  /*
    Bulk import users from excel sheet uploaded by client
   */

  exports.bulkImport = function(req, res, next) {
    var baseUrl, classeId, destFile, file, orgId, policy, request, resourceKey, tempUrl, type;
    resourceKey = req.body.key;
    orgId = req.body.orgId;
    type = req.body.type;
    classeId = req.body.classeId;
    if (type == null) {
      return res.send(400);
    }
    if (orgId == null) {
      return res.send(400);
    }
    if (type === 'studnet' && (classeId == null)) {
      return res.send(400);
    }
    baseUrl = qiniu.rs.makeBaseUrl(qiniuDomain, resourceKey);
    policy = new qiniu.rs.GetPolicy();
    tempUrl = policy.makeRequest(baseUrl);
    destFile = config.tmpDir + path.sep + 'user_list.xlsx';
    file = fs.createWriteStream(destFile);
    return request = http.get(tempUrl, function(stream) {
      stream.pipe(file);
      return file.on('finish', function() {
        return file.close(function() {
          var importReport, importedUser, obj, userList;
          console.log('Start parsing file...');
          obj = xlsx.parse(destFile);
          userList = obj.worksheets[0].data;
          if (!userList) {
            console.error('Failed to parse user list file or empty file');
            res.send(500);
            return;
          }
          importReport = {
            total: 0,
            success: [],
            failure: []
          };
          importedUser = [];
          return _.forEach(userList, function(userItem) {
            var newUser;
            console.log('UserItem is ...');
            console.log(userItem);
            newUser = new User({
              name: userItem[0].value,
              email: userItem[1].value,
              role: type,
              password: userItem[1].value,
              orgId: orgId
            });
            return newUser.save(function(err, user) {
              importReport.total += 1;
              if (err) {
                console.error('Failed to save user ' + newUser.name);
                importReport.failure.push(err.errors);
              } else {
                console.log('Created user ' + newUser.name);
                importReport.success.push(newUser.name);
                importedUser.push(user._id);
              }
              if (importReport.total === userList.length) {
                if (type === 'student') {
                  return updateClasseStudents(res, classeId, importedUser, importReport);
                } else {
                  return res.json(200, importReport);
                }
              }
            });
          });
        });
      });
    }).on('error', function(err) {
      console.error('There is an error while downloading file from ' + url);
      fs.unlink(dest);
      return res.send(500);
    });
  };

  exports.forget = function(req, res) {
    var crypto;
    if (req.body.email == null) {
      return res.send(400);
    }
    crypto = require('crypto');
    return crypto.randomBytes(21, function(err, buf) {
      var conditions, fieldsToSet, token;
      if (err) {
        return res.send(400);
      }
      token = buf.toString('hex');
      conditions = {
        email: req.body.email.toLowerCase()
      };
      fieldsToSet = {
        resetPasswordToken: token,
        resetPasswordExpires: Date.now() + 10000000
      };
      return User.findOneAndUpdate(conditions, fieldsToSet, function(err, user) {
        var options;
        if (err) {
          return res.send(400);
        }
        if (!user) {
          return res.send(400);
        }
        options = {
          from: req.app.config.smtp.from.name + ' <' + req.app.config.smtp.from.address + '>',
          to: user.email,
          subject: 'Reset your ' + req.app.config.projectName + ' password',
          textPath: 'users/forgot/email-text',
          htmlPath: 'users/forgot/email-html',
          locals: {
            username: user.name,
            resetLink: req.protocol + '://' + req.headers.host + '/login/reset/' + user.email + '/' + token + '/',
            projectName: req.app.config.projectName
          },
          success: function(message) {
            return res.send(201);
          },
          error: function(err) {
            return res.json(404, err);
          }
        };
        return req.app.utility.sendmail(req, res, options);
      });
    });
  };

  exports.reset = function(req, res) {
    var conditions;
    if (req.body.password == null) {
      return res.send(400);
    }
    conditions = {
      email: req.params.email.toLowerCase(),
      resetPasswordToken: req.params.token,
      resetPasswordExpires: {
        $gt: Date.now()
      }
    };
    return User.findOne(conditions, function(err, user) {
      if (err) {
        return res.send(400);
      }
      if (!user) {
        return res.send(400);
      }
      user.password = req.body.password;
      return user.save(function(err) {
        if (err) {
          return helpers.validationError(res, err);
        }
        return res.send(200);
      });
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

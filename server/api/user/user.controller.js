(function() {
  'use strict';
  var Classe, User, config, fs, helpers, http, jwt, passport, path, qiniu, qiniuDomain, updateClasseStudents, xlsx, _;

  User = _u.getModel("user");

  Classe = _u.getModel('classe');

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

  qiniu.conf.ACCESS_KEY = config.qiniu.access_key;

  qiniu.conf.SECRET_KEY = config.qiniu.secret_key;

  qiniuDomain = config.qiniu.domain;


  /*
    Get list of users
    restriction: 'admin'
   */

  exports.index = function(req, res, next) {
    return User.findQ({}, '-salt -hashedPassword').then(function(users) {
      return res.send(users);
    }, function(err) {
      return next(err);
    });
  };


  /*
    Creates a new user
   */

  exports.create = function(req, res, next) {
    var body;
    body = req.body;
    body.provider = 'local';
    return User.createQ(body).then(function(user) {
      var token;
      token = jwt.sign({
        _id: user._id
      }, config.secrets.session, {
        expiresInMinutes: 60 * 5
      });
      return res.json({
        token: token
      });
    }, function(err) {
      return next(err);
    });
  };


  /*
    Get a single user
   */

  exports.show = function(req, res, next) {
    var userId;
    userId = req.params.id;
    return User.findByIdQ(userId).then(function(user) {
      return res.send(user.profile);
    }, function(err) {
      return next(err);
    });
  };


  /*
    Get a single user by email
   */

  exports.showByEmail = function(req, res, next) {
    return User.findOneQ({
      email: req.params.email
    }).then(function(user) {
      if (user == null) {
        return res.send(404);
      }
      return res.send(user.profile);
    }, function(err) {
      return next(err);
    });
  };


  /*
    Deletes a user
    restriction: 'admin'
   */

  exports.destroy = function(req, res, next) {
    return User.findByIdAndRemoveQ(req.params.id).then(function(user) {
      return res.send(user);
    }, function(err) {
      return next(err);
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
    return User.findByIdQ(userId).then(function(user) {
      if (user.authenticate(oldPass)) {
        user.password = newPass;
        return user.save(function(err) {
          if (err) {
            return next(err);
          }
          return res.send(200);
        });
      } else {
        return res.send(403);
      }
    }, function(err) {
      return next(err);
    });
  };


  /*
    Get my info
   */

  exports.me = function(req, res, next) {
    var userId;
    userId = req.user.id;
    return User.findOneQ({
      _id: userId
    }, '-salt -hashedPassword').then(function(user) {
      if (user == null) {
        return res.send(401);
      }
      return res.send(user);
    }, function(err) {
      return next(err);
    });
  };


  /*
    Update user
   */

  exports.update = function(req, res, next) {
    if (req.body._id != null) {
      delete req.body._id;
    }
    if (req.body.password != null) {
      delete req.body.password;
    }
    return User.findByIdQ(req.params.id).then(function(user) {
      var updated;
      if (user == null) {
        return res.send(404);
      }
      updated = _.merge(user, req.body);
      return updated.saveQ();
    }).then(function(user) {
      return res.send(user);
    }, function(err) {
      return next(err);
    });
  };

  updateClasseStudents = function(res, next, classeId, studentList, importReport) {
    return Classe.findByIdQ(classeId).then(function(classe) {
      if (classe == null) {
        return res.send(404);
      }
      logger.info('Found classe with id ');
      classe.students = _.merge(classe.students, studentList);
      classe.markModified('students');
      logger.info('After merge, classe is: ' + classe);
      return classe.saveQ();
    }).then(function(saved) {
      return res.send(importReport);
    }, function(err) {
      return next(err);
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
    if (type === 'student' && (classeId == null)) {
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
                  return updateClasseStudents(res, next, classeId, importedUser, importReport);
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

  exports.forget = function(req, res, next) {
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

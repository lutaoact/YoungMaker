'use strict';

var mongoose = require('mongoose');
var passport = require('passport');
var config = require('../config/environment');
var jwt = require('jsonwebtoken');
var expressJwt = require('express-jwt');
var compose = require('composable-middleware');
var User = _u.getModel("user");

/**
 * Attaches the user object to the request if authenticated
 * Otherwise returns 403
 */
function isAuthenticated(credentialsRequired) {
  var validateJwt = expressJwt({ secret: config.secrets.session, credentialsRequired: credentialsRequired })
  return compose()
    // Validate jwt
    .use(function(req, res, next) {
      // allow access_token to be passed through query parameter as well
      if(req.query && req.query.hasOwnProperty('access_token')) {
        req.headers.authorization = 'Bearer ' + req.query.access_token;
      }
      validateJwt(req, res, next);
    })
    // Attach user to request
    .use(function(req, res, next) {
      if (!req.user) return next();
      User.findById(req.user._id, function (err, user) {
        if (err) return next(err);
        if (!user) return res.send(401);

        req.user = user;
        next();
      });
    });
}

/**
 * Checks if the user role meets the minimum requirements of the route
 */
function hasRole(roleRequired) {
  if (!roleRequired) throw new Error('Required role needs to be set');

  return compose()
    .use(isAuthenticated())
    .use(function meetsRequirements(req, res, next) {
      if (config.userRoles.indexOf(req.user.role) >= config.userRoles.indexOf(roleRequired)) {
        next();
      }
      else {
        res.send(403);
      }
    });
}

/**
 * Returns a jwt token signed by the app secret
 */
function signToken(id) {
  return jwt.sign({ _id: id}, config.secrets.session, { expiresInMinutes: config.tokenExpireTime});
}

/**
 * Set token cookie directly for oAuth strategies
 */
function setTokenCookie(req, res, redirect) {
  if (!req.user) return res.json(404, { message: 'Something went wrong, please try again.'});
  var token = signToken(req.user._id);
  res.cookie('token', JSON.stringify(token));
  res.redirect(redirect);
}

function verifyTokenCookie() {
  return compose()
    .use(function(req, res, next) {
      if (req.cookies.token) {
        var token = req.cookies.token.replace(/"/g, '');
        jwt.verify(token, config.secrets.session, null, function(err, user) {
          if (err) return next(err);
          if (user) req.user = user;

          next();
        });
      } else {
        next();
      }
    })
    .use(function(req, res, next) {
        if (req.user) {
          User.findById(req.user._id, function (err, user) {
            if (err) return next(err);
            if (user) req.user = user;

            next();
          });
        } else {
          next();
        }
    });
}
exports.verifyTokenCookie = verifyTokenCookie;

exports.isAuthenticated = isAuthenticated;
exports.hasRole = hasRole;
exports.signToken = signToken;
exports.setTokenCookie = setTokenCookie;

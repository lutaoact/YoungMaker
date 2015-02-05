'use strict';

var express = require('express');
var passport = require('passport');
var config = require('../config/environment');
var User = _u.getModel("user");

// Passport Configuration
require('./local/passport').setup(User, config);
require('./passport');

var router = express.Router();

router.use('/local', require('./local'));

var auth = require("./auth.service")
router.get('/weibo', passport.authenticate('weibo'));
router.get('/weibo/callback', auth.verifyTokenCookie(), function(req, res, next) {
  passport.authenticate('weibo', function(err, user, info) {
    if (err) return res.json(401, err);
    //如果有信息传出，则将信息以cookie的形式传给前端
    if (info) {
      res.clearCookie('qq_profile')
      res.cookie('weibo_profile', JSON.stringify(info));
      return res.redirect('/social');
    }

    req.user = user
    auth.setTokenCookie(req, res, req.query.redirect);
  })(req, res, next);
});

router.get('/qq', passport.authenticate('qq'));
router.get('/qq/callback', auth.verifyTokenCookie(), function(req, res, next) {
  passport.authenticate('qq', function(err, user, info) {
    if (err) return res.json(401, err);

    //如果有信息传出，则将信息以cookie的形式传给前端
    if (info) {
      res.clearCookie('weibo_profile')
      res.cookie('qq_profile', JSON.stringify(info));
      return res.redirect('/social');
    }

    req.user = user
    auth.setTokenCookie(req, res, req.query.redirect);
  })(req, res, next);
});

router.get('/weixin/callback', auth.verifyTokenCookie(), function(req, res, next) {
  passport.authenticate('weixin', function(err, user, info) {
    if (err) return next(err)

    req.user = user
    console.log('weixin/callback ' + req.query.redirect);
    auth.setTokenCookie(req, res, req.query.redirect);
  })(req, res, next);
});

router.get('/weixin_userinfo/callback', function(req, res, next) {
  passport.authenticate('weixin_userinfo', function(err, user, info) {
    if (err) return next(err);

    if (user) {
      req.user = user;
      auth.setTokenCookie(req, res, '/mobile');
    } else {
      res.redirect('/mobile');
    }
  })(req, res, next);
});

module.exports = router;

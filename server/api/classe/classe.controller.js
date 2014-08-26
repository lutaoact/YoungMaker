(function() {
  "use strict";
  var Classe;

  Classe = _u.getModel("classe");

  exports.index = function(req, res, next) {
    var user;
    user = req.user;
    return Classe.findQ({
      orgId: user.orgId
    }).then(function(classes) {
      logger.info(classes);
      return res.send(classes);
    }, function(err) {
      return next(err);
    });
  };

  exports.show = function(req, res, next) {
    var classeId, user;
    user = req.user;
    classeId = req.params.id;
    return Classe.findOneQ({
      _id: classeId,
      orgId: user.orgId
    }).then(function(classe) {
      logger.info(classe);
      return res.send(classe);
    }, function(err) {
      console.log(err);
      return next(err);
    });
  };

  exports.showStudents = function(req, res, next) {
    var classeId, user;
    user = req.user;
    classeId = req.params.id;
    return Classe.findOne({
      _id: classeId,
      orgId: user.orgId
    }).populate('students').execQ().then(function(classe) {
      return res.send(classe.students);
    }, function(err) {
      return next(err);
    });
  };

  exports.create = function(req, res, next) {
    var body;
    body = req.body;
    body.orgId = req.user.orgId;
    return Classe.createQ(body).then(function(classe) {
      logger.info(classe);
      return res.json(201, classe);
    }, function(err) {
      return next(err);
    });
  };

  exports.update = function(req, res, next) {
    var body, classeId;
    classeId = req.params.id;
    body = req.body;
    if (body._id) {
      delete body._id;
    }
    return Classe.findByIdQ(classeId).then(function(classe) {
      var updated;
      updated = _.extend(classe, body);
      return updated.saveQ();
    }).then(function(res) {
      var newClasse;
      newClasse = res[0];
      logger.info(newClasse);
      return res.send(newClasse);
    }, function(err) {
      return next(err);
    });
  };

  exports.destroy = function(req, res, next) {
    var classeId;
    classeId = req.params.id;
    return Classe.removeQ({
      _id: classeId
    }).then(function() {
      return res.send(204);
    }, function(err) {
      return next(err);
    });
  };

}).call(this);

//# sourceMappingURL=classe.controller.js.map

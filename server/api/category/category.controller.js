(function() {
  "use strict";
  var Category;

  Category = _u.getModel("category");

  exports.index = function(req, res, next) {
    return Category.findQ({}).then(function(categories) {
      return res.send(categories);
    }, function(err) {
      return next(err);
    });
  };

  exports.create = function(req, res, next) {
    var body;
    body = req.body;
    return Category.createQ(body).then(function(category) {
      return res.json(201, category);
    }, function(err) {
      return next(err);
    });
  };

  exports.destroy = function(req, res, next) {
    return Category.removeQ({
      _id: req.params.id
    }).then(function() {
      return res.send(204);
    }, function(err) {
      return next(err);
    });
  };

}).call(this);

//# sourceMappingURL=category.controller.js.map

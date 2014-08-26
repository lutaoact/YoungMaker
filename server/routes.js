(function() {
  'use strict';
  var errorHandler, errors;

  errors = require('./components/errors');

  errorHandler = function(err, req, res, next) {
    var util;
    logger.error(err);
    util = require('util');
    return res.json(err.status || 500, util.inspect(err));
  };

  module.exports = function(app) {
    app.use('/api/things', require('./api/thing'));
    app.use('/api/users', require('./api/user'));
    app.use('/api/courses', require('./api/course'));
    app.use('/api/categories', require('./api/category'));
    app.use('/api/classes', require('./api/classe'));
    app.use('/api/organizations', require('./api/organization'));
    app.use('/api/solutions', require('./api/solution'));
    app.use('/api/qiniu', require('./api/qiniu'));
    app.use('/api/lectures', require('./api/lecture'));
    app.use('/api/class_progresses', require('./api/class_progress'));
    app.use('/api/knowledge_points', require('./api/knowledge_point'));
    app.use('/auth', require('./auth'));
    app.use(errorHandler);
    app.route('/:url(api|auth|components|app|bower_components|assets)/*').get(errors[404]);
    return app.route('/*').get(function(req, res) {
      return res.sendfile(app.get('appPath') + '/index.html');
    });
  };

}).call(this);

//# sourceMappingURL=routes.js.map

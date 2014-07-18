/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');

module.exports = function(app) {

  // Insert routes below
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

  app.use('/auth', require('./auth'));

  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*')
   .get(errors[404]);

  // All other routes should redirect to the index.html
  app.route('/*')
    .get(function(req, res) {
      res.sendfile(app.get('appPath') + '/index.html');
    });
};

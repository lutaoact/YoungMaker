(function() {
  var Classe, Course, CourseUtils, classe, course, user;

  require('./init');

  course = {
    name: 'xxxxx',
    categoryId: '111111111111111111111112',
    thumbnail: 'yyyy',
    owners: ['111111111111111111111111', '222222222222222222222222']
  };

  classe = {
    name: 'classe',
    orgId: '333333333333333333333333',
    students: ['444444444444444444444444']
  };

  Course = _u.getModel('course');

  Classe = _u.getModel('classe');

  CourseUtils = _u.getUtils('course');

  user = {
    role: 'student',
    _id: '444444444444444444444444'
  };

  CourseUtils.getAuthedCourseById(user, '53f9b1cd67b02bc1220d556b').then(function(course) {
    return console.log(course);
  }, function(err) {
    console.log('this is error');
    return console.log(err);
  });

}).call(this);

//# sourceMappingURL=modelTest.js.map

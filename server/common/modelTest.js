(function() {
  var Classe, Course, CourseUtils, LectureUtils, classe, course, student, teacher;

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

  LectureUtils = _u.getUtils('lecture');

  student = {
    role: 'student',
    _id: '53fbf7e19b43e4a2375266ff'
  };

  teacher = {
    role: 'teacher',
    _id: '53fbf7e19b43e4a2375266fe'
  };

  LectureUtils.getAuthedLectureById(teacher, '53fbf7e19b43e4a237526708').then(function(lecture) {
    return console.log(lecture);
  }, function(err) {
    return console.log(err);
  });

}).call(this);

//# sourceMappingURL=modelTest.js.map

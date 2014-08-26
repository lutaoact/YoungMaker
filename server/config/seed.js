(function() {
  'use strict';
  var AsyncClass, Category, Classe, Course, Organization, User, actions, categoryId, data, mClasse, mLecture, name, orgId, ownerId, removeAndCreate, seedData, studentId;

  require('../common/init');

  AsyncClass = require('../common/AsyncClass').AsyncClass;

  seedData = require('./seed_data');

  removeAndCreate = function(name, data) {
    var Model;
    Model = _u.getModel(name);
    return Model.removeQ({}).then(function() {
      return Model.createQ(data);
    }).then(function(docs) {
      return docs;
    }, function(err) {
      return Q.reject(err);
    });
  };

  actions = (function() {
    var _results;
    _results = [];
    for (name in seedData) {
      data = seedData[name];
      _results.push(removeAndCreate(name, data));
    }
    return _results;
  })();

  User = _u.getModel('user');

  Classe = _u.getModel('classe');

  Course = _u.getModel('course');

  Category = _u.getModel('category');

  Organization = _u.getModel('organization');

  orgId = void 0;

  ownerId = void 0;

  studentId = void 0;

  categoryId = void 0;

  mClasse = void 0;

  mLecture = void 0;

  Q.all(actions).then(function(results) {
    return User.findOneQ({
      email: 'teacher@teacher.com'
    });
  }).then(function(user) {
    ownerId = user.id;
    return Category.findOneQ({});
  }).then(function(category) {
    categoryId = category.id;
    return Organization.findOneQ({
      uniqueName: 'cloud3'
    });
  }).then(function(organization) {
    orgId = organization.id;
    return User.findOneQ({
      email: 'student@student.com'
    });
  }).then(function(student) {
    studentId = student.id;
    return removeAndCreate('classe', {
      name: 'Class one',
      orgId: orgId,
      students: [studentId],
      yearGrade: '2014'
    });
  }).then(function(classe) {
    mClasse = classe;
    return removeAndCreate('lecture', {
      name: 'lecture 1'
    });
  }).then(function(lecture) {
    mLecture = lecture;
    return removeAndCreate('course', {
      name: 'Music 101',
      categoryId: categoryId,
      thumbnail: 'http://test.com/thumb.jpg',
      info: 'This is course music 101',
      owners: [ownerId],
      classes: [mClasse._id],
      lectureAssembly: [mLecture._id]
    });
  }).then(function() {
    return console.log('success');
  }, function(err) {
    return console.log(err);
  });

}).call(this);

//# sourceMappingURL=seed.js.map

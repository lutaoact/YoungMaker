(function() {
  module.exports = {
    category: (function() {
      var value, _i, _len, _ref, _results;
      _ref = ['初一物理', '初二物理', '初三物理'];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        value = _ref[_i];
        _results.push({
          name: value
        });
      }
      return _results;
    })(),
    user: [
      {
        provider: 'local',
        name: 'Test User',
        email: 'test@test.com',
        password: 'test'
      }, {
        provider: 'local',
        role: 'admin',
        name: 'Admin',
        email: 'admin@admin.com',
        password: 'admin'
      }, {
        provider: 'local',
        role: 'teacher',
        name: 'Teacher',
        email: 'teacher@teacher.com',
        password: 'teacher'
      }, {
        provider: 'local',
        role: 'student',
        name: 'Student',
        email: 'student@student.com',
        password: 'student'
      }
    ],
    key_point: [
      {
        name: '三种淡黄色固体'
      }, {
        name: 'AgBr的光解'
      }
    ],
    organization: [
      {
        name: 'Cloud3 Edu',
        logo: 'http://cloud3edu.com/logo.jpg',
        uniqueName: 'cloud3',
        description: 'This is a test organization',
        type: 'school'
      }
    ],
    thing: [
      {
        name: 'Development Tools',
        info: 'Integration with'
      }, {
        name: 'Server and Client integration',
        info: 'Built with a powerful'
      }
    ]
  };

}).call(this);

//# sourceMappingURL=seed_data.js.map

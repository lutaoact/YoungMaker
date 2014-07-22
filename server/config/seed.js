/**
 * Populate DB with sample data on server start
 * to disable, edit config/environment/index.js, and set `seedDB: false`
 */

'use strict';

var Thing = require('../api/thing/thing.model');
var User = require('../api/user/user.model');
var Category = require('../api/category/category.model');

Thing.find({}).remove(function() {
  Thing.create({
    name : 'Development Tools',
    info : 'Integration with popular tools such as Bower, Grunt, Karma, Mocha, JSHint, Node Inspector, Livereload, Protractor, Jade, Sass, CoffeeScript, and Less.'
  }, {
    name : 'Server and Client integration',
    info : 'Built with a powerful and fun stack: MongoDB, Express, AngularJS, and Node.'
  }, {
    name : 'Smart Build System',
    info : 'Build system ignores `spec` files, allowing you to keep tests alongside code. Automatic injection of scripts and styles into your index.html'
  },  {
    name : 'Modular Structure',
    info : 'Best practice client and server structures allow for more code reusability and maximum scalability'
  },  {
    name : 'Optimized Build',
    info : 'Build process packs up your templates as a single JavaScript payload, minifies your scripts/css/images, and rewrites asset names for caching.'
  },{
    name : 'Deployment Ready',
    info : 'Easily deploy your app to Heroku or Openshift with the heroku and openshift subgenerators'
  });
});

User.find({}).remove(function() {
  User.create({
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
  }, function() {
      console.log('finished populating users');
    }
  );
});

Category.find({}).remove(function() {
  Category.create({
    name:'初一物理',
  },{
    name:'初二物理',
  },{
    name:'初三物理',
  },{
    name:'初一化学',
  },{
    name:'初二化学',
  },{
    name:'初三化学',
  },{
    name:'初一数学',
  },{
    name:'初二数学',
  },{
    name:'初三数学',
  },{
    name:'初一英语',
  },{
    name:'初二英语',
  },{
    name:'初三英语',
  },{
    name:'初一语文',
  },{
    name:'初二语文',
  },{
    name:'初三语文',
  },{
    name:'高一物理',
  },{
    name:'高二物理',
  },{
    name:'高三物理',
  },{
    name:'高一化学',
  },{
    name:'高二化学',
  },{
    name:'高三化学',
  },{
    name:'高一数学',
  },{
    name:'高二数学',
  },{
    name:'高三数学',
  },{
    name:'高一英语',
  },{
    name:'高二英语',
  },{
    name:'高三英语',
  },{
    name:'高一语文',
  },{
    name:'高二语文',
  },{
    name:'高三语文',
  })
})

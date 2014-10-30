'use strict'

angular.module('mauiApp').config ($stateProvider) ->

  $stateProvider.state 'admin.teacherManager',
    url: '/teachers'
    templateUrl: 'app/admin/teacherManager/teacherManager.html'
    controller: 'TeacherManagerCtrl'
    authenticate: true

  .state 'admin.teacherManager.detail',
    url: '/:teacherId'
    templateUrl: 'app/admin/teacherManager/teacherManagerDetail.html'
    controller: 'TeacherManagerDetailCtrl'
    authenticate: true

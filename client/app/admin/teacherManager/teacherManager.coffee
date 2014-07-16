'use strict'

angular.module('budweiserApp').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.when("/admin", "/admin/teacherManager")
  $stateProvider.state 'admin.teacherManager',
    url: '/teacherManager'
    templateUrl: 'app/admin/teacherManager/teacherManager.html'
    controller: 'TeacherManagerCtrl'


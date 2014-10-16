'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider.state 'admin.teacherManager',
    url: '/teacherManager'
    templateUrl: 'app/admin/teacherManager/teacherManager.html'
    controller: 'TeacherManagerCtrl'
    authenticate: true


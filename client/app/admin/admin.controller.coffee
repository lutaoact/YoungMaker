'use strict'

angular.module('budweiserApp').controller 'AdminCtrl', (
  $scope
  webview
) ->

  angular.extend $scope,
    webview: webview
    menus: [
     stateName:'admin.home'
     label: '机构管理'
    ,
     stateName:'admin.teacherManager'
     label: '教师管理'
    ,
      stateName:'admin.classeManager'
      label: '班级和学生'
    ,
      stateName:'admin.categoryManager'
      label: '学科管理'
    ]


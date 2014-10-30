'use strict'

angular.module('mauiApp')

.directive 'editTeacherTile', ->
  restrict: 'EA'
  replace: true
  controller: 'EditUserTileCtrl'
  templateUrl: 'app/admin/teacherManager/editTeacherTile.html'
  scope:
    user: '='
    canDelete: '@'
    infoEditable: '@'
    onUpdateUser: '&'
    onDeleteUser: '&'


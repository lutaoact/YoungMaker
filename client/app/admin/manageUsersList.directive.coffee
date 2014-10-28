'use strict'

angular.module('budweiserApp')

.directive 'manageUsersList', ->
  restrict: 'EA'
  replace: true
  controller: 'ManageUsersListCtrl'
  templateUrl: 'app/admin/manageUsersList.html'
  scope:
    users: '='
    classe: '='
    userRole: '@'
    onCreateUser: '&'
    onDeleteUser: '&'
    onViewUser: '&'

.controller 'ManageUsersListCtrl', (
  $q
  Auth
  $scope
  $modal
  notify
  fileUtils
  Restangular
) ->

  updateSelected = ->
    $scope.selectedUsers =  _.filter($scope.users, '$selected':true)

  addNewUserSuccess = (newUser) ->
    notify
      message: "新#{$scope.roleTitle}添加成功"
      classes: 'alert-success'
    $scope.onCreateUser?($data:newUser)

  angular.extend $scope,

    toggleSelectAllUsers: false
    selectedUsers: []

    importing: false
    deleting: false

    roleTitle:
      switch $scope.userRole
        when 'student' then '学生'
        when 'teacher' then '教师'
        when 'admin'   then '管理员'
        else throw 'unknown user.role ' + $scope.userRole

    addNewUser: ->
      $modal.open
        templateUrl: 'app/admin/newUserModal.html'
        controller: 'NewUserModalCtrl'
        resolve:
          userRole: -> $scope.userRole
          orgUniqueName: -> Auth.getCurrentUser().orgId.uniqueName
      .result.then (newUser) ->
        if $scope.classe?
          newUsers = _.union $scope.classe.students, [newUser._id]
          $scope.classe?.patch(students:newUsers).then addNewUserSuccess
        else
          addNewUserSuccess()

    showDetail: (user) ->
      $scope.onViewUser?($user:user)

    toggleSelect: (users, selected) ->
      angular.forEach users, (u) -> u.$selected = selected
      updateSelected()

    deleteUsers: (users) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> "删除#{$scope.roleTitle}"
          message: ->
            """确认要删除这#{users.length}个#{$scope.roleTitle}？"""
      .result.then ->
        $scope.toggledSelectAllUsers = false if $scope.toggledSelectAllUsers
        $scope.deleting = true
        Restangular.all('users').customPOST(ids: _.pluck(users, '_id'), 'multiDelete')
        .then ->
          done = ->
            $scope.deleting = false
            $scope.onDeleteUser?(users)

          if $scope.classe?
            newUsers = _.difference($scope.users, users)
            $scope.classe.patch(students: _.pluck newUsers, '_id').then done
          else
            done()

    importUsers: (files)->
      $scope.importing = true

      fail = (error) ->
        $scope.importing = false
        notify
          message: '批量导入失败 ' + error.data
          classes: 'alert-danger'

      success = (report) ->
        console.debug report
        $scope.importing = false
        addNewUserSuccess(report)

      fileUtils.uploadFile
        files: files
        validation:
          max: 50 * 1024 * 1024
          accept: 'excel'
        success: (key)->
          Restangular.all('users').customPOST
            key: key
            type: $scope.userRole
            classeId: $scope.classe._id
          , 'bulk'
          .then success
          .catch fail
        fail: fail
        progress: ->
          console.debug 'uploading...'

  $scope.$watch 'users.length', updateSelected

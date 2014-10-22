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

  angular.extend $scope,

    toggleSelectAllUsers: false
    selectedUsers: []
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
        done = ->
          notify
            message: '新学生添加成功'
            classes: 'alert-success'
          $scope.onCreateUser?($data:newUser)

        if $scope.classe?
          newUsers = _.union $scope.classe.students, [newUser._id]
          $scope.classe?.patch(students:newUsers).then done
        else
          done()


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
          title: -> '删除学生'
          message: ->
            """确认要删除这#{users.length}个学生？"""
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

  $scope.$watch 'users', updateSelected

  #TODO refactor
  $scope.isExcelProcessing = false
  $scope.onFileSelect = (files)->
    $scope.isExcelProcessing = true
    fileUtils.uploadFile
      files: files
      validation:
        max: 50 * 1024 * 1024
        accept: 'excel'
      success: (key)->
        Restangular.all('users').customPOST
          key: key
          type: $scope.userRole
          classeId: $scope.classeId
        , 'bulk'
        .then ->
          $scope.onCreateUser?()
          $scope.isExcelProcessing = false
        , (error)->
          console.log error
          $scope.isExcelProcessing = false
      fail: (error)->
        notify
          message: error
          classes: 'alert-danger'
        $scope.isExcelProcessing = false
      progress: ->
        console.debug 'uploading...'

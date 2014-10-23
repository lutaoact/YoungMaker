'use strict'

angular.module('budweiserApp')

.controller 'TeacherManagerDetailCtrl', (
  $state
  $scope
  $modal
  notify
  chartUtils
  Restangular
) ->

  editingKeys = [
    'name'
    'email'
    'avatar'
    'info'
  ]

  resetSelectedCourse = ->
    selectedCourse = _.find($scope.courses, _id:$scope.selectedCourse?._id) ? $scope.courses?[0]
    angular.extend $scope.selectedCourse, selectedCourse

  angular.extend $scope,
    $state: $state
    courses: null
    selectedCourse: {}
    teacher: null
    saving: false
    saved: true

    onAvatarUploaded: (key) ->
      $scope.teacher.avatar = key
      $scope.teacher.patch avatar: key
      .then ->
        notify
          message: '头像修改成功'
          classes: 'alert-success'

    saveProfile: (form) ->
      if !form.$valid then return
      $scope.saving = true
      $scope.teacher.patch($scope.editingInfo).then ->
        angular.extend $scope.teacher, $scope.editingInfo
        $scope.saving = false
        $scope.reloadTeachers()
        notify
          message: '基本信息已保存'
          classes: 'alert-success'

    removeTeacher: (teacher) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        size: 'sm'
        resolve:
          title: -> '删除教师'
          message: ->
            """确认要删除教师"#{teacher.name}"？"""
      .result.then ->
        teacher.remove().then ->
          notify
            message: '该教师已被删除'
            classes: 'alert-success'
          $state.go('admin.teacherManager')
          $scope.reloadTeachers()

  Restangular.one('users', $state.params.teacherId).get()
  .then (teacher) ->
    $scope.teacher = teacher
    $scope.editingInfo = _.pick $scope.teacher, editingKeys

  Restangular.all('courses').getList(teacherId: $state.params.teacherId)
  .then (courses) ->
    $scope.courses = courses
    resetSelectedCourse()

  $scope.$watch 'selectedCourse._id', resetSelectedCourse

  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.teacher, editingKeys)
  , (isEqual) ->
    $scope.saved = isEqual

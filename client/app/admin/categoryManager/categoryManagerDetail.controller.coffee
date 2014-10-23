'use strict'

angular.module('budweiserApp')

.controller 'CategoryManagerDetailCtrl', (
  $scope
  $state
  notify
) ->

  editingKeys = [
    'name'
  ]

  angular.extend $scope,

    eidtingInfo: null
    saved: false

    saveCategory: (form) ->
      if !form.$valid  || $scope.saved then return
      $scope.selectedCategory.patch $scope.editingInfo
      .then (category)->
        angular.extend $scope.selectedCategory, category
        notify
          message: """"#{category.name}"信息已保存"""
          categorys: 'alert-success'

    reloadStudents: ->
      $scope.selectedCategory?.all('students').getList()
      .then (students) ->
        $scope.selectedCategory.students = _.pluck students, '_id'
        $scope.selectedCategory.$students = students

    viewStudent: (student) ->
      $state.go('admin.categoryManager.detail.student', categoryId:$scope.selectedCategory._id, studentId:student._id)

  $scope.$parent.selectedCategory = _.find($scope.categories, _id:$state.params.categoryId)
  $scope.editingInfo = _.pick $scope.selectedCategory, editingKeys
  $scope.reloadStudents()

  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.selectedCategory, editingKeys)
  , (isEqual) ->
    $scope.saved = isEqual

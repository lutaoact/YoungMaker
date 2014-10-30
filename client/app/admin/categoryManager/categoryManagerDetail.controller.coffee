'use strict'

angular.module('budweiserApp')

.controller 'CategoryManagerDetailCtrl', (
  $scope
  $state
  notify
) ->

  # 能编辑的字段
  editableFields = [
    'name'
  ]

  angular.extend $scope,

    eidtingInfo: null
    courses: null
    saved: false

    saveCategory: (form) ->
      if !form.$valid  || $scope.saved then return
      $scope.selectedCategory.patch $scope.editingInfo
      .then (category)->
        angular.extend $scope.selectedCategory, category
        notify
          message: '专业名称修改成功'
          classes: 'alert-success'
      .catch (error) ->
        notify
          message: error?.data?.errors?.name?.message
          classes: 'alert-danger'

    reloadCourses: ->
      $scope.selectedCategory?.all('courses').getList()
      .then (courses) ->
        $scope.courses = courses

    viewCourse: (course) ->
      $state.go('admin.categoryManager.detail.course', categoryId:$scope.selectedCategory._id, courseId:course._id)

  $scope.$parent.selectedCategory = _.find($scope.categories, _id:$state.params.categoryId)
  $scope.editingInfo = _.pick $scope.selectedCategory, editableFields
  $scope.reloadCourses()

  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.selectedCategory, editableFields)
  , (isEqual) ->
    $scope.saved = isEqual

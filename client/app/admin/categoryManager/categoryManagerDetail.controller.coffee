'use strict'

angular.module('budweiserApp')

.controller 'CategoryManagerDetailCtrl', (
  $scope
  $state
) ->

  editingKeys = [
    'name'
  ]

  angular.extend $scope,

    eidtingInfo: null
    courses: null

    reloadCourses: ->
      $scope.selectedCategory?.all('courses').getList()
      .then (courses) ->
        $scope.courses = courses

    viewCourse: (course) ->
      $state.go('admin.categoryManager.detail.course', categoryId:$scope.selectedCategory._id, courseId:course._id)

  $scope.$parent.selectedCategory = _.find($scope.categories, _id:$state.params.categoryId)
  $scope.editingInfo = _.pick $scope.selectedCategory, editingKeys
  $scope.reloadCourses()

  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.selectedCategory, editingKeys)
  , (isEqual) ->
    $scope.saved = isEqual

'use strict'

describe 'Controller: TeacherCourseStatsCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  TeacherCourseStatsCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    TeacherCourseStatsCtrl = $controller('TeacherCourseStatsCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

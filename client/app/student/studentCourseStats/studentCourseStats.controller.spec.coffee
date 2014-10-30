'use strict'

describe 'Controller: StudentCourseStatsCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  StudentCourseStatsCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    StudentCourseStatsCtrl = $controller('StudentCourseStatsCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

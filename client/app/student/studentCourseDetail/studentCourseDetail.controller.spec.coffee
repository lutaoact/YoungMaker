'use strict'

describe 'Controller: StudentCourseDetailCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  StudentCourseDetailCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    StudentCourseDetailCtrl = $controller('StudentCourseDetailCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

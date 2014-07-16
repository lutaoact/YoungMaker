'use strict'

describe 'Controller: StudenthomeCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  StudenthomeCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    StudenthomeCtrl = $controller('StudenthomeCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

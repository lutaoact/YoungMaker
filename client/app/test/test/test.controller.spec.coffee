'use strict'

describe 'Controller: TestCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  TestCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    TestCtrl = $controller('TestCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

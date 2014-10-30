'use strict'

describe 'Controller: XqshCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  XqshCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    XqshCtrl = $controller('XqshCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

'use strict'

describe 'Controller: SecurityCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  SecurityCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    SecurityCtrl = $controller('SecurityCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

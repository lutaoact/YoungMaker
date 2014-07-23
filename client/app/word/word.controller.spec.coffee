'use strict'

describe 'Controller: WordCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  WordCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    WordCtrl = $controller('WordCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

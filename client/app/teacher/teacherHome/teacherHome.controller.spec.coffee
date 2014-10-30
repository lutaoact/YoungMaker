'use strict'

describe 'Controller: TeacherhomeCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  TeacherhomeCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    TeacherhomeCtrl = $controller('TeacherhomeCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

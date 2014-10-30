'use strict'

describe 'Controller: TeachermanagerCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  TeachermanagerCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    TeachermanagerCtrl = $controller('TeachermanagerCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

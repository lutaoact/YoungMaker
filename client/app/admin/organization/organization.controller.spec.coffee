'use strict'

describe 'Controller: OrganizationCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  OrganizationCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    OrganizationCtrl = $controller('OrganizationCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

'use strict'

describe 'Controller: OrganizationManagerCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  OrganizationCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    OrganizationCtrl = $controller('OrganizationManagerCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

'use strict'

describe 'Controller: BillingCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  BillingCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    BillingCtrl = $controller('BillingCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

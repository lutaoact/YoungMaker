'use strict'

describe 'Controller: CategoryManagerCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  CategoryManagerCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    CategoryManagerCtrl = $controller('CategoryManagerCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

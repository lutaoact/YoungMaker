'use strict'

describe 'Controller: ClassemanagerCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  ClassemanagerCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    ClassemanagerCtrl = $controller('ClassemanagerCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

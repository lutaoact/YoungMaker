'use strict'

describe 'Controller: ForumHomeCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  ForumHomeCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    ForumHomeCtrl = $controller('ForumHomeCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

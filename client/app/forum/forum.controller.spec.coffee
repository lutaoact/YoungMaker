'use strict'

describe 'Controller: ForumCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  ForumCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    ForumCtrl = $controller('ForumCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

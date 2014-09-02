'use strict'

describe 'Controller: ForumTopicCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  ForumTopicCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    ForumTopicCtrl = $controller('ForumTopicCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

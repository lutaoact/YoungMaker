'use strict'

describe 'Controller: ForumDiscussionCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  ForumDiscussionCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    ForumDiscussionCtrl = $controller('ForumDiscussionCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

'use strict'

describe 'Controller: ForumCourseCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  ForumCourseCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    ForumCourseCtrl = $controller('ForumCourseCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

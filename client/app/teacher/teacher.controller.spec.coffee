'use strict'

describe 'Controller: TeacherCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  TeacherCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    TeacherCtrl = $controller('TeacherCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

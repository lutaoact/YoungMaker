'use strict'

describe 'Controller: StudentHomeCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  StudentHomeCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    StudentHomeCtrl = $controller('StudentHomeCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

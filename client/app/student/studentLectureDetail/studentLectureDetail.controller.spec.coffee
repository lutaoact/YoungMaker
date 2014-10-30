'use strict'

describe 'Controller: StudentLectureDetailCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  StudentLectureDetailCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    StudentLectureDetailCtrl = $controller('StudentLectureDetailCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

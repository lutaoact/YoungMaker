'use strict'

describe 'Controller: StudentCourseListCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  StudentCourseListCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    StudentCourseListCtrl = $controller('StudentCourseListCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

'use strict'

describe 'Controller: TeacherCourseDetailCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  TeacherCourseDetailCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    TeacherCourseDetailCtrl = $controller('TeacherCourseDetailCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

'use strict'

describe 'Controller: TeacherCourseCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  TeachercourseCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    TeachercourseCtrl = $controller('TeacherCourseCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

describe 'Controller: TeacherCourseNewCtrl', ->

  # load the controller's module
  beforeEach module('budweiserApp')
  TeachercoursenewCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    TeachercoursenewCtrl = $controller('TeacherCourseNewCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

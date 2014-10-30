'use strict'

describe 'Controller: TeacherLectureCtrl', ->

  # load the controller's module
  beforeEach module('mauiApp')
  TeacherLectureCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    TeacherLectureCtrl = $controller('TeacherLectureCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1

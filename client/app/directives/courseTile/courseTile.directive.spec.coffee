'use strict'

describe 'Directive: studentCourseTile', ->

  # load the directive's module and view
  beforeEach module('budweiserApp')
  beforeEach module('app/student/studentCourseTile/studentCourseTile.html')
  element = undefined
  scope = undefined
  beforeEach inject(($rootScope) ->
    scope = $rootScope.$new()
  )
  it 'should make hidden element visible', inject(($compile) ->
    element = angular.element('<course-tile></course-tile>')
    element = $compile(element)(scope)
    scope.$apply()
    expect(element.text()).toBe 'this is the studentCourseTile directive'
  )

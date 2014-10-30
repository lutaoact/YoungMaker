'use strict'

describe 'Directive: studentList', ->

  # load the directive's module and view
  beforeEach module('mauiApp')
  beforeEach module('app/directives/student-list/student-list.html')
  element = undefined
  scope = undefined
  beforeEach inject(($rootScope) ->
    scope = $rootScope.$new()
  )
  it 'should make hidden element visible', inject(($compile) ->
    element = angular.element('<student-list></student-list>')
    element = $compile(element)(scope)
    scope.$apply()
    expect(element.text()).toBe 'this is the studentList directive'
  )

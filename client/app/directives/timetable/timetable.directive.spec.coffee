'use strict'

describe 'Directive: timetable', ->

  # load the directive's module and view
  beforeEach module('mauiApp')
  beforeEach module('app/directives/timetable/timetable.html')
  element = undefined
  scope = undefined
  beforeEach inject(($rootScope) ->
    scope = $rootScope.$new()
  )
  it 'should make hidden element visible', inject(($compile) ->
    element = angular.element('<timetable></timetable>')
    element = $compile(element)(scope)
    scope.$apply()
    expect(element.text()).toBe 'this is the timetable directive'
  )

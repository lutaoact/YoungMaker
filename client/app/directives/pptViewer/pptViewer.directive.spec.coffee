'use strict'

describe 'Directive: pptViewer', ->

  # load the directive's module and view
  beforeEach module('budweiserApp')
  beforeEach module('app/directives/pptViewer/pptViewer.html')
  element = undefined
  scope = undefined
  beforeEach inject(($rootScope) ->
    scope = $rootScope.$new()
  )
  it 'should make hidden element visible', inject(($compile) ->
    element = angular.element('<ppt-viewer></ppt-viewer>')
    element = $compile(element)(scope)
    scope.$apply()
    expect(element.text()).toBe 'this is the pptViewer directive'
  )

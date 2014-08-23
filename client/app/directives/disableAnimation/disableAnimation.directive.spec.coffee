'use strict'

describe 'Directive: disableAnimation', ->

  # load the directive's module
  beforeEach module('budweiserApp')
  element = undefined
  scope = undefined
  beforeEach inject(($rootScope) ->
    scope = $rootScope.$new()
  )
  it 'should make hidden element visible', inject(($compile) ->
    element = angular.element('<disable-animation></disable-animation>')
    element = $compile(element)(scope)
    expect(element.text()).toBe 'this is the disableAnimation directive'
  )
'use strict'

describe 'Directive: isScrolledAboveView', ->

  # load the directive's module
  beforeEach module('budweiserApp')
  element = undefined
  scope = undefined
  beforeEach inject(($rootScope) ->
    scope = $rootScope.$new()
  )
  it 'should make hidden element visible', inject(($compile) ->
    element = angular.element('<is-scrolled-above-view></is-scrolled-above-view>')
    element = $compile(element)(scope)
    expect(element.text()).toBe 'this is the isScrolledAboveView directive'
  )
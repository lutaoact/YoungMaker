'use strict'

describe 'Directive: fixWhenReachTop', ->

  # load the directive's module
  beforeEach module('budweiserApp')
  element = undefined
  scope = undefined
  beforeEach inject(($rootScope) ->
    scope = $rootScope.$new()
  )
  it 'should make hidden element visible', inject(($compile) ->
    element = angular.element('<fix-when-reach-top></fix-when-reach-top>')
    element = $compile(element)(scope)
    expect(element.text()).toBe 'this is the fixWhenReachTop directive'
  )
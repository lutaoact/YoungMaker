'use strict'

describe 'Directive: loginForm', ->

  # load the directive's module and view
  beforeEach module('mauiApp')
  beforeEach module('app/directives/loginForm/loginForm.html')
  element = undefined
  scope = undefined
  beforeEach inject(($rootScope) ->
    scope = $rootScope.$new()
  )
  it 'should make hidden element visible', inject(($compile) ->
    element = angular.element('<login-form></login-form>')
    element = $compile(element)(scope)
    scope.$apply()
    expect(element.text()).toBe 'this is the loginForm directive'
  )

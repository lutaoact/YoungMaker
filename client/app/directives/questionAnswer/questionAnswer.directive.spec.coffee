'use strict'

describe 'Directive: questionAnswer', ->

  # load the directive's module and view
  beforeEach module('mauiApp')
  beforeEach module('app/directives/questionAnswer/questionAnswer.html')
  element = undefined
  scope = undefined
  beforeEach inject(($rootScope) ->
    scope = $rootScope.$new()
  )
  it 'should make hidden element visible', inject(($compile) ->
    element = angular.element('<question-answer></question-answer>')
    element = $compile(element)(scope)
    scope.$apply()
    expect(element.text()).toBe 'this is the questionAnswer directive'
  )

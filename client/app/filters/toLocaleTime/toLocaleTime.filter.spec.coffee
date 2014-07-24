'use strict'

describe 'Filter: toLocaleTime', ->

  # load the filter's module
  beforeEach module('budweiserApp')

  # initialize a new instance of the filter before each test
  toLocaleTime = undefined
  beforeEach inject(($filter) ->
    toLocaleTime = $filter('toLocaleTime')
  )
  it 'should return the input prefixed with \'toLocaleTime filter:\'', ->
    text = 'angularjs'
    expect(toLocaleTime(text)).toBe 'toLocaleTime filter: ' + text

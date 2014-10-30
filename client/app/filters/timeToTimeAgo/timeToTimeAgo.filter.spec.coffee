'use strict'

describe 'Filter: timeToTimeAgo', ->

  # load the filter's module
  beforeEach module('mauiApp')

  # initialize a new instance of the filter before each test
  timeToTimeAgo = undefined
  beforeEach inject(($filter) ->
    timeToTimeAgo = $filter('timeToTimeAgo')
  )
  it 'should return the input prefixed with \'timeToTimeAgo filter:\'', ->
    text = 'angularjs'
    expect(timeToTimeAgo(text)).toBe 'timeToTimeAgo filter: ' + text

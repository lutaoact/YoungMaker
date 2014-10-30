'use strict'

describe 'Filter: htmlToPlaintext', ->

  # load the filter's module
  beforeEach module('budweiserApp')

  # initialize a new instance of the filter before each test
  htmlToPlaintext = undefined
  beforeEach inject(($filter) ->
    htmlToPlaintext = $filter('htmlToPlaintext')
  )
  it 'should return the input prefixed with \'htmlToPlaintext filter:\'', ->
    text = 'angularjs'
    expect(htmlToPlaintext(text)).toBe 'htmlToPlaintext filter: ' + text

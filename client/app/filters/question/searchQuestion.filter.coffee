'use strict'

angular.module('budweiserApp').filter 'searchQuestion', ->
  (items, keyword) ->
    keyword = _.str.clean(keyword ? '').toLowerCase()
    _.filter items, (item) ->
      title = item.content?.title ? ''
      options = _.map(item.content.body, (option) -> option.desc).toString()
      questionText = _.str.clean(title + " " + options).toLowerCase()
      _.str.include(questionText, keyword)
angular.module('mauiApp')

.filter 'questionTitle', ->
  QUESTION_STRING_REG = /(<img src='.*' class='question-image'>)/g
  (content) ->
    content.replace QUESTION_STRING_REG, ' [图片]'

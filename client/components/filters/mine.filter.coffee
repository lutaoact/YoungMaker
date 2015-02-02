angular.module('maui.components')

.filter 'mine', (Auth) ->
  (item, isMine) ->
    label =
      if isMine
        '我的'
      else
        'TA的'
    item.replace('#mine#', label)

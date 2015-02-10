angular.module('maui.components')

.filter 'mine', (Auth) ->
  (item, isMine, mineText, otherText) ->
    label =
      if isMine
        mineText or '我的'
      else
        otherText or 'Ta的'
    item.replace('#mine#', label)
